# 数据结构
1. 有哪些常用的数据结构？
2. `character`和`factor`有何区别？如何相互转换？谈谈你对`factor`的理解。
3. `matrix`与`dataframe`有何区别？如何相互转换？
4. `dataframe`与`list`有何联系和区别？
5. 谈谈你对`list`的理解，如果需要可用代码示例。
6. 如何判断某个变量是不是某种数据类型？
7. `NULL`和`NA`有什么区别？

# 数据操作
#### 数据导入
> 在R中，如果不是必须用`factor`的地方，尽量避免使用`factor`，否则会带来一些意想不到的问题。通常在导入数据的时候默认`character`类型自动转换为`factor`，可以参考`read.table`的`stringsAsFactors`参数。最好在脚本最开头处设定`options(stringsAsFactors = False)`，这样就不会把字符串转换为`factor`。

```r
# 一些用factor可能造成的错误示例
> x <- factor(6:10)
> x
[1] 6  7  8  9  10
Levels: 6 7 8 9 10
> as.numeric(x)
[1] 1 2 3 4 5
> as.numeric(as.character(x))
[1]  6  7  8  9 10
```

1. 仔细阅读上面一段话，以及代码，谈谈对你它们的理解。
2. 用R导入数据后需要做哪些检查？

#### 数据初探
1. 如何查看一个`dataframe`的前几行或者最后几行？
2. 对一个`dataframe`调用`str`函数，看看结果。
3. 回答以上两个操作在什么时候会比较有用。

# *apply系列
1. 列一个表，从输入，输出，功能等方面比较一下这几个函数：`apply`, `tapply`, `sapply`, `rapply`, `mapply`
2. 自己构造一个`matrix`数据集，全都是数字，通过`apply`函数取出一半以上的列大于0的行。
3. 自己构造一个`dataframe`数据集，第一列是人名，第二列是消费金额，每个人有多项消费金额，用两种方法得到每人最贵的消费，并通过循环多次比较这两种方法用时长短。
    * 通过`tapply`函数
    * 通过`dplyr`

# R packages
## dplyr
1. 回答通过这个包操作数据与原生操作相比有何优势？

## reshape2 
1. 阅读此教程：http://seananderson.ca/2013/10/19/reshape.html. 自己操作并理解教程中的代码，回答`reshape2`好哪里？

## stringr
1. 阅读此教程：https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html. 自己操作并理解教程中的代码，对R中如何操作字符串做到心中有数。
2. 如何有困难，自己找资料学习正则表达式(regular expressions).

# 其他
1. `dataframe`行名或者列名可否重复？如果可以，你认为这样做好吗？通过代码回答。
2. 谈谈你对向量化运算的理解。为什么在`R`中需要尽量用向量化运算？可用代码说明。
3. `%in%`有什么用途？通过代码说明。
4. `%>%`有什么用途？通过代码说明。

