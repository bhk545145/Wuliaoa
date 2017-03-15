#Usage

iOS / Android  开发的小伙伴们，下面说明如何使用各种 APP 中的 ```webview``` 模板。

##Development

```
node build.js -a // 构建所有模板

node build.js quote-list-table // 只构建quote-list-table模板

node build.js quote-list-table -t // 构建quote-list-table，并插入template数据
```

##Bubble

1. 请把 ```build``` 目录 中的 ```bubble.html``` 下载下来，放入你的工程中

2. 将 ```bubble.html``` 的 ```${webview_content}``` 替换成冒泡 json 中的 ```content```

3. 将替换过后的 html 内容塞到 ```webview``` 中即可。

4. 完毕，请鼓掌！

##Topic

*注意,```build```目录中

```topic-ios.html``` 为 ```iOS``` 的讨论模板

```topic-android.html``` 为 ```Android``` 的讨论模板

将 ``${webview_content}``` 替换成 json 中的 ```content```


##Code
> build/code.html 是为 “代码预览” 准备的模板

将 ```code.html``` 中的 ```${file_code}``` 替换为代码,对应数据[^1]中的 ```file.data```

将 ```code.html``` 中的 ```${file_lang}``` 替换为代码语言,对应数据中的 ```file.lang```


##Markdown
>build/markdown.html 是为 “代码预览” 中预览 ```lang``` 为 ```markdown``` 的文件准备的模板

将 ```markdown.html``` 中的 ```${webview_content}``` 替换为对应数据中的 ```file.preview```

*注意： ```file.lang``` 为 ```markdown```

[^1]: 数据来源于： /api/user/:username/project/:project_name/git/blob/:file_path 接口


##Diff
> build/diff.html 显示 commit 中的 diff
将 ```diff.html``` 中的 ```${diff-content}``` 替换为获取到的数据。（获取到的应该是 JSON 数据，要将 JSON 转换成字符串）


##Quote List Table
> build/quote-list-table.html 是码市 App 报价单“功能清单”的图表模板

将`quote-list-table.html`中的`${webview_content}`替换为清单数据，格式如`template/quote.json`
