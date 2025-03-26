# **Go의 가비지 컬렉터(GC) 자세한 설명**

## **1. Go의 가비지 컬렉터(GC)란?**
**Go의 가비지 컬렉터(GC, Garbage Collector)**는 **사용하지 않는 메모리를 자동으로 회수하여 메모리 누수를 방지하고 프로그램이 안정적으로 동작하도록 도와주는 기능**입니다.  
GC는 Heap 메모리를 자동으로 관리하여 개발자가 직접 `free()` 같은 메모리 해제 함수를 호출할 필요가 없습니다.

### **💡 Go GC의 목표**
- **짧은 정지 시간 (Low Pause Time)**
- **짧은 응답 지연 (Low Latency)**
- **높은 처리량 (High Throughput)**
- **멀티코어에서 효율적인 동작 (Scalability)**

---

## **2. Go GC의 동작 방식**
Go의 GC는 **Mark-and-Sweep 알고리즘**을 기반으로 작동하지만, 최신 버전에서는 더 최적화된 방식으로 개선되었습니다.

### **(1) Mark-and-Sweep 개요**
1. **Mark 단계**:
    - 사용 중인 객체(참조되고 있는 객체)를 **표시(Mark)**
2. **Sweep 단계**:
    - 사용되지 않는 객체를 **해제(Sweep)**

하지만 이 방식은 **애플리케이션의 실행을 멈추는(Pause)** 시간이 길어지는 단점이 있습니다.

---

## **3. 최신 Go GC의 특징 (Low-Pause GC)**
Go의 최신 가비지 컬렉터는 기존 **Mark-and-Sweep**을 개선하여 **"Concurrent (동시 실행) & Incremental (점진적)" 방식**을 사용합니다.

### **(1) Concurrent Mark-and-Sweep**
- **GC가 프로그램과 동시에 실행됨** (애플리케이션의 실행을 멈추지 않음)
- **GC 작업을 여러 개의 작은 작업으로 쪼개어 점진적으로 실행**
- **Stop-the-world(중단) 시간이 최소화됨**

### **(2) Generational GC (Go 1.22+)**
- **젊은 객체(Young Generation)와 오래된 객체(Old Generation)를 구분하여 관리**
- **대부분의 객체는 짧은 생명주기를 가지므로 Young Generation에서 빠르게 해제**
- **Young Generation에서 살아남은 객체만 Old Generation으로 이동**

---

## **4. Go GC 최적화 기법**
**GC는 필요하지만, 불필요한 GC 호출을 줄이면 성능을 향상시킬 수 있습니다.**  
다음 방법을 활용하면 GC 부담을 줄일 수 있습니다.

### ✅ **1) 불필요한 Heap 할당 줄이기**
Go의 **Escape Analysis**를 활용하면 Stack 할당을 늘려 GC 부담을 줄일 수 있습니다.

```go
// ❌ Heap 할당 발생 (GC 부담 증가)
func createPointer() *int {
    num := 42
    return &num
}

// ✅ Stack 할당 (GC 부담 감소)
func createValue() int {
    return 42
}
```

### ✅ **2) 객체 재사용하기 (sync.Pool 활용)**
`sync.Pool`을 사용하면 **자주 사용하는 객체를 재사용**하여 GC 호출을 줄일 수 있습니다.

```go
import "sync"

var bufPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024) // 1KB 버퍼 할당
    },
}

func process() {
    buf := bufPool.Get().([]byte) // 객체 가져오기
    defer bufPool.Put(buf)        // 사용 후 다시 Pool에 저장
}
```

### ✅ **3) 슬라이스(slice) 대신 배열(array) 사용**
```go
// ❌ Heap 할당 발생
func createSlice() []int {
    return make([]int, 1000) // GC 대상
}

// ✅ Stack에서 할당 가능
func createArray() [1000]int {
    var arr [1000]int
    return arr // GC 부담 감소
}
```

### ✅ **4) GC 조정 (GOGC 환경 변수 사용)**
`GOGC`(Garbage Collection Percentage) 값을 조정하면 GC 동작 빈도를 조절할 수 있습니다.

```sh
# 기본값은 100 (100% 증가할 때마다 GC 실행)
export GOGC=50  # GC 실행 빈도를 높임 (메모리 사용량 줄어듦)
export GOGC=200 # GC 실행 빈도를 낮춤 (성능 향상, 메모리 사용 증가)
```

**동적 변경도 가능**
```go
import "runtime"

runtime.GC()         // 강제 GC 실행
runtime.SetGCPercent(200) // GC 실행 빈도를 낮춤
```

---

## **5. GC 동작 확인 방법**
Go 프로그램에서 GC 동작을 분석하는 방법을 알아봅시다.

### ✅ **1) `GODEBUG=gctrace=1` 사용**
```sh
GODEBUG=gctrace=1 go run main.go
```
이렇게 실행하면 **GC 실행 로그**를 출력합니다.
```
gc 1 @2.934s 3%: 0.062+1.0+0.11 ms clock, 0.25+1.0/2.1/1.2+0.44 ms cpu, 4->4->0 MB, 5 MB goal, 4 P
```

### ✅ **2) `pprof`를 사용한 GC 분석**
```sh
go run -memprofile mem.out main.go
go tool pprof mem.out
```
메모리 프로파일링을 수행하여 GC의 동작을 분석할 수 있습니다.

---

## **6. 결론**
- **Go GC는 Mark-and-Sweep을 기반으로 개선된 "Concurrent & Incremental GC" 방식**
- **Go 1.22부터는 Generational GC 적용**
- **Escape Analysis를 활용해 Heap 할당을 최소화하면 GC 부담을 줄일 수 있음**
- **sync.Pool, GOGC 조정, 메모리 프로파일링을 통해 성능 최적화 가능**

🚀 **최적의 GC 설정을 통해 Go 애플리케이션의 성능을 극대화하세요!** 🚀