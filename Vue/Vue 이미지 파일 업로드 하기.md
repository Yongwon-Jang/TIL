# Vue 이미지 파일 업로드 하기

- 두가지 방법
  - FileReader()를 사용하는 방법
  - URL.createObjectURL()을 쓰는 방법
- 이번 포스팅에서는 조금 더 간단한 두번째 방법을 활용해서 이미지 파일을 업로드 하는 법에 대해서 알아보겠습니다.



```vue
<input @change="upload()" type="file" id="file" />

methods : {
  upload(e){    # e 는 event와 관련된 자료
    let file = e.target.files;   # 내가 업로드한 파일이 다 담겨있다.
    let URL = URL.createObjectURL(file); # 내가 업로드한 파일 가져오는법
  }
}



input이 들어왔을 때 코드를 실행하고 싶을 때는 change 이벤트를 활용하면 된다.

- 추가 정보
파일을 여러개 업로드 하고 싶으면 multiple을 써준다.
<input @change="upload()" multiple type="file" id="file" />

이미지 형식만 업로드 받고싶을때 accpet
<input @change="upload()" accpet="image/*"multiple type="file" id="file" />
파일 선택할 때 이미지 파일만 볼 수 있게 해준다. 하지만 근본적인 해결 방법은 아님

console.log(file.type)을 치면 확장자를 검색할 수 있고 원하는 파일 타입만 받도록 제약해주면 된다.
```



```javascript
methods : {
  upload(e){    # e 는 event와 관련된 자료
    let file = e.target.files;   # 내가 업로드한 파일이 다 담겨있다.
    let URL = URL.createObjectURL(file); # 내가 업로드한 파일 가져오는법
  }
}
```



