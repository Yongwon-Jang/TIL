# Vue 애니메이션 주는 법

### CSS로 애니메이션 주는법

1. 애니메이션 시작 전 class를 디자인해놓고 

2. 애니메이션 동작 후 class를 디자인해놓습니다 

3. 그리고 원할 때 애니메이션 동작 후 class를 부착하면 됩니다. 예를 들면 모달창이 열릴 때요. 

4. 시작 전 class 명에 transition 속성을 주면 부드럽게 애니메이션이 완성됩니다. 

```vue
<div class="start end">
    <Modal />
</div>

<style>
    .start{
        opacity: 0; //투명한 정도
        transition: all 1s;
    }
    .end{
        opacity: 1;
    }
</style>
```



### Vue에서 제공하는 <transition>태그 이용

1. 애니메이션 주고 싶은 UI를 <transition name="작명"></transition>으로 감쌉니다. 

2. CSS로 다음과 같이 스타일을 주면 됩니다. 

```vue
<transition name="fade">
    <Modal />
</transition>

<style>
    등장할 때
    .fade-enter-from{
        opacity: 0;
    }
    .fade-enter-active{
        transition: all 1s;
    }
    .fade-enter-to{
        opacity: 1;
    }
    
    퇴장할 때
    .fade-leave-from{
        opacity: 1;
    }
    .fade-leave-active{
        transition: all 1s;
    }
    .fade-leave-to{
        opacity: 0;
    }
</style>
```

