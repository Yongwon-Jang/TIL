kubectl 명령어를 `k`로 줄여 쓰고, `k app<Tab>` 처럼 자동완성까지 되도록 하려면 다음 단계를 따르면 됩니다:

---

## ✅ 1. `kubectl` alias 생성 (이미 했다면 생략)

```bash
echo "alias k='kubectl'" >> ~/.bashrc
```

## ✅ 2. `kubectl` 자동완성 스크립트 등록

```bash
source <(kubectl completion bash)
```

## ✅ 3. alias `k`에도 자동완성 적용

```bash
echo "complete -F __start_kubectl k" >> ~/.bashrc
```

## ✅ 4. 변경사항 적용

```bash
source ~/.bashrc
```

---

## ✅ 확인

터미널에 `k get po` 또는 `k app<Tab>` 등 입력해보면 자동완성이 동작해야 합니다.

---

### 💡 Zsh 사용자라면?

```bash
echo "alias k='kubectl'" >> ~/.zshrc
echo "source <(kubectl completion zsh)" >> ~/.zshrc
echo "compdef k=kubectl" >> ~/.zshrc
source ~/.zshrc
```
