# 数据结构
1. 有哪些常用的数据结构？
向量(vector)、矩阵(matrix)、数组(array)、数据框(dataframe)、列表(list)
2. `character`和`factor`有何区别？如何相互转换？谈谈你对`factor`的理解。
* 区别
`character`指的是字符型数据，其中的内容是字符串，不能进行比较以及其他的运算。`factor`指的是因子，类别变量与有序型变量称为因子，虽然因子的标签常是字符串，但却代表着不同的水平或者层次。如果是有序型因子，则可进行比较，在后续的统计分析中，可以得出类似“随着某水平的增加，出现某趋势的结论”。字符型数据不可。
* 转换
x为字符，转因子：x<-as.factor(x)；x为因子转字符x<-as.character(x)
* 理解
变量有名义型、有序型、连续型，前两种可以归结为因子。也就是说需要分类的变量可以归结为因子。因子非常实用，可将字符型的数据变得可以比较，便于的数据分析与视觉呈现。
3. `matrix`与`dataframe`有何区别？如何相互转换？
首先，`matrix`与`dataframe`都是二维的。
区别：`matrix`中的数据必须mode一致，指的是，所有变量（行）的数据须统一为数值型、字符型、逻辑型其中的一种；`dataframe`各列数据的mode可以不一致，但同一列中每行的数据的mode必须一致。
转换：先根据行列的模式判断是否可转。如果是，
`matrix`转`dataframe`：as.data.frame();
`dataframe`转`matrix`：as.matrix(). 
4. `dataframe`与`list`有何联系和区别？
* 联系
dataframe与list都能容忍比较复杂的数据，mode可以不一致。
* 区别
维度不同：dataframe二维；list可多维。
结构不同：dataframe呈现出二维列表的结构，list更复杂，是一个个对象，可有数个不同的对象，最终归到一个`list`下。
`dataframe`每列数据个数是相同的，否则就要归为缺失值；list不一样，每个对象可以维度、结构、个数不相同。
5. 谈谈你对`list`的理解，如果需要可用代码示例。
理解：`list`像一个柜子，有若干不同的格子，每个格子可放不同的对象，可以将几个向量、数组、数据框、因子整合在这个柜子中。
```r
>a <- c(1,2,3,4,5)
>b <- matrix(6:20,nrow = 5)
>c <- data.frame(name=c("张三","李四","王五","赵六"),sex=c("M","M","F","F"),age=c(20,40,22,30),height=c(166,170,150,155))
>list(a,b,c)
[[1]]
[1] 1 2 3 4 5

[[2]]
     [,1] [,2] [,3]
[1,]    6   11   16
[2,]    7   12   17
[3,]    8   13   18
[4,]    9   14   19
[5,]   10   15   20

[[3]]
  name sex age height
1 张三   M  20    166
2 李四   M  40    170
3 王五   F  22    150
4 赵六   F  30    155
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
* 在实际操作中，最大的区别是NULL可以参与计算而NA不可，要剔除才能算。NULL不占位置，NA占位置，通过length函数可以看出。
```
> x <- c(2,8,56,4,NA,7,6,9)
> mean(x)
[1] NA
> x <- c(2,8,56,4,NULL,7,6,9)
> mean(x)
[1] 13.14286
```
* 在理解方面，NULL空值、无效的、无价值的、不存在的值；NA表示缺失值，存在但不知道或者有问题，所以not availabel不可用的值。
* NULL在写循环结构的时有用。
```
> x <- NULL
> for (i in 1:10) if (i %%2 ==0) x <- c(x,i)
> x
[1]  2  4  6  8 10
```
i为1到10的数，这10个值分别去试能否整除2，能则选到x中，所以先令x为空值，最后合并二者，即可将i中2的倍数选到x中。
如果不用`NULL`呢？
```
> for (i in 1:10) if (i %%2 ==0) print(i)
[1] 2
[1] 4
[1] 6
[1] 8
[1] 10
```
以上只能看到结果，不能得到一个向量，难以进行后续操作。
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
* 首先，将x赋值为一个level为6到10的因子，由于没有写label，默认为6到10这5个水平的标签（名字）也是6到10。
* 然后，将x转为数值，将level转为数字，默认为第一层转为1，尽管因子的第一层是6，依次类推。Level有五个，转成数值型，x向量就有5个数值。
* 然而，as.numeric(as.character(x))可以得到一个数字不变的数值。
步骤如下：先将x因子转成字符，6到10这5个level变成了普通的字符串，再使用as.numberic函数，将6到10这5个字符转成数值，最终得到一个值为6到10的数值 型向量。
2. 用R导入数据后需要做哪些检查？
第一，检查行和列。观察有无缺失的变量。观察变量名是否正确覆盖。
第二，检查每个变量的形式，有无将字符型、数值型数据转成因子的情况。如果有因子检查因子的水平和标签是否正确。
第三，检查缺失值等。

#### 数据初探
1. 如何查看一个`dataframe`的前几行或者最后几行？
*  查看前几行：`head(object,X)`，`object`是`dataframe`的名字，X是行数，需要显示几行就写几，默认显示6行。
* 查看后几行：`tail(object,X)`,用法同上。
2. 对一个`dataframe`调用`str`函数，看看结果。
```
> str(expense)
> str(expense)
'data.frame':	7 obs. of  6 variables:
 $ name      : chr  "Anne" "Amy" "Marry" "Bob" ...
 $ food      : num  700 950 1020 560 670 980 665
 $ living    : num  2300 3120 1200 1400 1480 ...
 $ traveling : num  1200 380 890 770 1100 1230 1430
 $ recreation: num  1200 1300 1340 340 560 780 900
 $ others    : num  1100 2300 23400 2100 780 560 1000
 ```
第一行，显示数据框变量与值的个数。
从第二行起，显示每个变量的信息，包括变量类型与数值。变量类型：num(数值)、chr(字符串)、factor(因子)等，若是有序型因子会标注因子内部编码的情况。如变量的数值不胜枚举，则显示前几个。
以此类推，给出所有变量的信息。
3. 回答以上两个操作在什么时候会比较有用。
* `head`和`tail`用于当数据过多，避免被数据刷屏，直接显示全部数据可能会卡，所以仅显示前或后的几行数据。关注前段就用`head`，关注后段用`tail`，通常用`head`。亦可同时使用，比如当用melt将宽数据转换为长数据，又进行了一定的排序，若只显示前几行，几十行，不足以窥探数据全貌，最好前后若干行同时显示，实用且美观。
* `Str`用在当我们不了解数据结构的时候，例如，从别处导入某数据，不了解每个变量的情况，也不了R如何处理各个变量，有无将字符型数据转为因子的情况。分别查看会非常麻烦，可用str，即可得知每个变量的信息。

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
2. 如果有困难，自己找资料学习正则表达式(regular expressions).

# 其他
1. `dataframe`行名或者列名可否重复？如果可以，你认为这样做好吗？通过代码回答。
```r
data.frame(..., row.names = NULL, check.rows = FALSE,
check.names = TRUE, stringsAsFactors =
default.stringsAsFactors())
```
根据数据框用法，如果`check.names = TRUE`则不能行名列名重复，反则反之。
将消费金额数据框expense行名列名改成一样试试
```
> names(expense) <- letters[1:6]
> row.names(expense) <- letters[1:7]
```
可以。
又进行了一些筛选列、排序等工作，无碍。但用`%in%`时有问题，得分开步骤写。估计再必须区别行列的时候也会有问题，我体会不深。
2. 谈谈你对向量化运算的理解。为什么在`R`中需要尽量用向量化运算？可用代码说明。
向量化运算的意思是：当输入的对象为向量时，对其中的每个元素分别进行处理，然后以向量的形式输出。向量在R中的意思是数据集，一串数据。
```
> x <- 1:10
> x+1
 [1]  2  3  4  5  6  7  8  9 10 11
> for(i in 1:10) print(i+1)
[1] 2
[1] 3
[1] 4
[1] 5
[1] 6
[1] 7
[1] 8
[1] 9
[1] 10
[1] 11
```
按这个道理，`apply`系列最能体现向量化的思想，可以进行一定的分组，然后在组中进行运算。
为什么要尽量向量化？
* 思路简单，既然`R`有函数可以实现循环功能，就不要写循环了。因为我只接触过`R`，无其他语言基础，这种思路对我来说是简单的。
* 代码也略微简洁些。
* 据说，运行会速度快。
3. `%in%`有什么用途？通过代码说明。
有匹配的用途。
`x %in% y`，x中有，y中也有的；`!x %in% y`, x中有，y中没有的。做逻辑判断，x中第一位y里有没有，有则TURE，没有FALSE，x中第二位……依次类推。
```
> x <- 1:6
> y <- 4:5
> x %in% y
[1] FALSE FALSE FALSE  TRUE  TRUE FALSE
> x[x %in% y]
[1] 4 5
> !x %in% y
[1]  TRUE  TRUE  TRUE FALSE FALSE  TRUE
> x[!x %in% y]
[1] 1 2 3 6
```
我们来看一个实际一点的例子，有这么两组数据：
```
> expense
    name food living traveling recreation others
1   Anne  700   2300      1200       1200   1100
2    Amy  950   3120       380       1300   2300
3  Marry 1020   1200       890       1340  23400
4    Bob  560   1400       770        340   2100
5 Bridge  670   1480      1100        560    780
6 Hector  980   2112      1230        780    560
7   Jack  665   1780      1430        900   1000
> spending
    name traveling clothes
1   Anne      1200    2300
2    Amy       380    4500
3  Marry       890    7800
4    Bob       770    1200
5 Bridge      1100     450
6 Hector      1230     900
7   Jack      1430     812
```
现在要找出`spending`数据中与`expense`不重复的列，合并成一个更完整的数据，可进行如下操作：
```
+       spending[!spending %in% expense]
+       )
    name food living traveling recreation others clothes
1   Anne  700   2300      1200       1200   1100    2300
2    Amy  950   3120       380       1300   2300    4500
3  Marry 1020   1200       890       1340  23400    7800
4    Bob  560   1400       770        340   2100    1200
5 Bridge  670   1480      1100        560    780     450
6 Hector  980   2112      1230        780    560     900
7   Jack  665   1780      1430        900   1000     812
```
过程：
```
> !spending %in% expense
[1] FALSE FALSE  TRUE
> spending[!spending %in% expense]
  clothes
1    2300
2    4500
3    7800
4    1200
5     450
6     900
7     812
```
`!spending %in% expense`找到`spending`中有`expense`中没有的，对列做了逻辑判断，在`spending`中第一列重复，第二列重复，第三列不重复。
`spending[!spending %in% expense]`将重复的列选出来。
最后合并。
**数据框按列匹配。且帮助文档中说匹配`list`比较慢。**
4. `%>%`有什么用途？通过代码说明。
省略代码的中间步骤，上一步操作的结果向右输送成为下一行函数的第一个参数（通常为data）。
* 用途一，简单，略去第一个参数。
* 用途二，美观，代码可读性强，省略中间变量，很干净。

举例，比如上述构建的有关有多个人消费的数据框，统计每个人的最大消费项目，且排序。
```
> expense %>%
+     group_by(name) %>%
+     mutate(per_person_max = max(food,living,traveling,recreation,others)) %>%
+     arrange(-(per_person_max))
Source: local data frame [7 x 7]
Groups: name [7]

    name  food living traveling recreation others per_person_max
  <fctr> <dbl>  <dbl>     <dbl>      <dbl>  <dbl>          <dbl>
1  Marry  1020   1200       890       1340  23400          23400
2    Amy   950   3120       380       1300   2300           3120
3   Anne   700   2300      1200       1200   1100           2300
4 Hector   980   2112      1230        780    560           2112
5    Bob   560   1400       770        340   2100           2100
6   Jack   665   1780      1430        900   1000           1780
7 Bridge   670   1480      1100        560    780           1480
```
再举例，比如我们将最大消费项目超过2500元的人定义为高消费组，我们现在关心高\低消费组的恩格尔系数，可以看看两组人在食物方面的支出，看看是否高消费组平均食物标准高。
```
> expense %>%
+     group_by(name) %>%
+     mutate(per_person_max = max(food,living,traveling,recreation,others)) %>%
+     mutate(over2500 = per_person_max > 2500) %>%
+     group_by(over2500) %>%
+     summarise(mean(food, na.rm = T))
# A tibble: 2 × 2
  over2500 `mean(food, na.rm = T)`
     <lgl>                   <dbl>
1    FALSE                     715
2     TRUE                     985
```
