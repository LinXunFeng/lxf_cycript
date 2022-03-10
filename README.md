# Cycript 工具集

## 使用
将 `lxf.cy` 拷贝至下方路径下

```shell
/usr/lib/cycript0.9/com/lxf/
```

然后在 `cycript` 环境下执行：

```shell
cy# @import com.lxf.lxf; 0
```

注：分号后面的`0` 是为了隐藏脚本导入后的脚本内容输出

## 疑难杂症

1、导入后不生效？

`ctrl + d` 退出 `cycript` 环境，把目标 `App` 杀掉重开再进入 `cycript` 导入即可