# Router

1. router 설치

```bash
npm install vue-router@4
```

- vue3 버전과 호환되는 router버전이 @4이다.



2. src에 router.js 파일 만들고 입력

```js
import { createWebHistory, createRouter } from "vue-router";

const routes = [
  {
    path: "/경로",
    component: import해온 컴포넌트,
  },
  {
    path: '/detail/:id',
    component: Detail,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router; 
```



3. main.js에

```js
import 작명 from '@/router.js'

createApp(App).use(작명).mount('#app')



ex) 
```



4. {{ $route.params.파라미터명 }}





### nasted routes

- 라우터에서 또 쪼개고 싶을때 사용

```js
  {
    path: "/detail/:id",
    component: Detail,
    children: [
      {
        path: "author",
        component: Author, 
      },
      {
        path: "comment",
        component: Comment,
      }
    ]
  },
```

이런식으로 children 작성하면 된다.

```vue
<router-view></router-view>
```

detail 페이지에서는 보여주고 싶은 곳에 이거 작성
