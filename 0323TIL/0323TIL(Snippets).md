## Snippets 사용하기

### 순서

- vscode 열기

- File

- Preferences

- User Snippets

- django.json.code-snippets 파일에 들어간다

  - 코드 구조

  ```json
  	"BASE HTML" : { 
  		"scope": "html, django-html",
  		"prefix": "bh",  # 스니펫을 사용할때 불러올 이름
  		"body": [        # 바디에 저장할 내용을 담는다. 주의할 점은 줄마다 쌍따옴표로 감싸야 하고 안에있는 쌍따옴표는 \"로 모두 바꿔준다.
  			"<!DOCTYPE html>",
  			"<html lang=\"en\">",
  			"<head>",
  			"	<meta charset=\"UTF-8\">",    # 앞에 간격까지 맞춰줘야 한다.
  			"	<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">",
  			"	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
  			"	<title>Document</title>",
  			"</head>",
  			"<body>",
  			"	<div class=\"container\">",
  			"		{% block content %}",
  			"		{% endblock %}",
  			"	</div>",
  			"</body>",
  			"</html>",
  		],
  		"description": "Django Base HTML"   # 스니펫에대한 설명, 없어도 된다.
  	},
  
  	# 이런 방식으로 자기가 원하는 코드를 계속 저장해 나가면 된다.
  ```

  