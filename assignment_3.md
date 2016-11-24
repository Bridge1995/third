# To Mavis H
###### Happy thanks giving day，太浓墨重彩的话不好说出口。
# 数据结构
1. 有哪些常用的数据结构？
>向量(vector)、矩阵(matrix)、数组(array)、数据框(dataframe)、列表(list)
2. `character`和`factor`有何区别？如何相互转换？谈谈你对`factor`的理解。
>区别：`character`指的是字符型数据，都是字符串，不能进行比较以及其他的运算。`Factor`指的是因子，标签虽然常常是字符的形式，但却代表着不同的水平或者层次。因子如果因子的水平是有序的，可以进行比较，再后续的统计分析中，可以得出类似“随着某水平的增加，出现某趋势的结论”。
> 转换：x为字符，转因子：x<-as.factor(x)；x为因子转字x<-as.character(x)
    理解：变量有名义型、有序型、连续型，前两种可以归结为因子。因子非常有用，可以将字符型的数据变得可以比较，方便后续的数据分析与视觉呈现。
3. `matrix`与`dataframe`有何区别？如何相互转换？
>首先，`matrix`与`dataframe`都是二维的。
>区别：`matrix`中的数据必须mode一致，指的是，所有行列的数据必须是数值型、字符型、逻辑型其中的一种；`dataframe`各列数据的mode可以不一致，但同一列中每行的数据的mode必须一致。
>转换：先根据行列的模式判断是否可转。如果是，
`matrix`转`dataframe`：as.data.frame();
                          `dataframe`转`matrix`：as.matrix(). 
4. `dataframe`与`list`有何联系和区别？
> ###### 联系
>dataframe与list都能容忍比较复杂的数据，mode可以不一致。
>###### 区别
>维度不同：dataframe二维；list多维。
结构不同：dataframe呈现出二维列表的结构，list更复杂是一个个对象，可有数个不同的对象，归到一个对象下。
>Dataframe行与列的数据数目是相同的，否则就要归为缺失值；list不一样，每个对象可以维度、结构、数值数目不相同。
5. 谈谈你对`list`的理解，如果需要可用代码示例。
   理解：list像一个柜子，有若干不同的格子，每个格子可放不同的对象，可以将几个向    量、数组、数据框、因子整合在这个柜子中。
```r
>a <- c(1,2,3,4,5)
>b <- matrix(6:20,nrow = 5)
>c <- data.frame(name=c("张三","李四","王五","赵六"),sex=c("M","M","F","F"),age=c(20,40,22,30),height=c(166,170,150,155))
>list(a,b,c)
```

6. 如何判断某个变量是不是某种数据类型？
```
>is.numberic()
>is.characer()
>is.logical()
>is.factor()
```
将会得到TRUE或FALSE
7. `NULL`和`NA`有什么区别？
>在实际操作中，最大的区别是NULL可以参与计算而NA不可，要剔除才能算。NULL不占位    置，NA占位置，通过length函数可以看出。
> 在理解方面，NULL空值、无效的、无价值的；NA缺失值not availabel不可用的值。
>例如统计松花江水运数量，在11月、12月、1月、2月处标NULL，因为冰封停运、没数值    没意义，相当于列表时画一个杠，标志空值。NA表示值有问题，不能参与计算，比如问    卷调查90几岁的年龄，标为NA，然后去掉，以免平均年龄高得离谱。

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
> 首先，将x赋值为一个level为6到10的因子，由于没有写label，默认为6到10这5个水平    的标签（名字）也是6到10。
> 然后，将x转为数值型，level转为数字，默认为第一层转为1，尽管因子的第一层是6，依次类推。Level有五个，转成数值型，x向量就有5个数值。
>最终，as.numeric(as.character(x))可以得到一个数字不变的数值型向量，尽管以前    的x的6到10是因子的水平，但经过as.numeric(as.character(x))可以将6到10变成普通数字。
>步骤如下：先将x因子转成字符型变量，6到10这5个level变成了普通的字符串，再使用as.numberic函数，将6到10这5个字符转成数值，最终得到一个值为6到10的数值    型向量。
2. 用R导入数据后需要做哪些检查？
> 第一，检查行和列，行和列通常代表着变量。当数据是由其他格式导入的，需要检查行    名列名，观察有无缺失的变量，变量名是否覆盖。
> 第二，检查每个变量的形式，有无将字符型、数值型数据转成因子的情况。如果有因子    检查因子的水平和标签是否正确。
> 第三，检查缺失值等。

#### 数据初探
1. 如何查看一个`dataframe`的前几行或者最后几行？
> 查看前几行：head(object,X)，object是dataframe的名字，X是行数，需要显示几行就写几，默认显示6行。
> 查看后几行：tail(object,X),用法同上。
2. 对一个`dataframe`调用`str`函数，看看结果。
>第一行，显示数据框变量与值的个数。
>从第二行起，显示每个变量的信息。首先，会告诉我们此变量是num(数值)、chr(字符串)、factor(因子)等，如果是有序型因子会标注因子内部编码的情况x<y。然后，显示每个变量的前几个数值。
>以此类推，给出所有变量的信息。
3. 回答以上两个操作在什么时候会比较有用。
> Head和tail当数据过多，避免被数据刷屏，避免直接输入data name显示全部数据，R会卡住，所以仅显示前几行或者后几行数据就。关注前段就用head，关注后段用tail，通常用head。亦可两者同时使用，比如当用melt将宽数据转换为长数据，又进行了一定的排序，若只显示前几行，几十行，不足以窥探数据全貌，最好前后若干行一起显示，实用且美观。
> Str用在当我们不了解数据结构的时候，例如，从别处导入一个数据，不了解每个变量的情况，也不了R如何处理各个变量，有无将字符型数据转为因子的情况。分别查看会非常麻烦，可用str，它会清楚地告诉我们数据中每个变量的信息。

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
