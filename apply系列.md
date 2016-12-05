# *apply系列
#### 1. 列表对比apply, tapply, sapply, rapply, mapply
<table>
   <tr>
      <td>函数</td>
      <td>用法</td>
      <td>第一个参数</td>
      <td>第二个参数</td>
      <td>第三个参数</td>
      <td>第四个参数</td>
      <td>输入</td>
      <td>输出</td>
      <td>功能</td>
      <td>备注</td>
   </tr>
   <tr>
      <td>apply</td>
      <td>apply(X, MARGIN, FUN, ...)</td>
      <td>X为要计算的数据</td>
      <td>MARGIN为行或者列，1行，2列</td>
      <td>FUN表示函数，对数据进行的操作</td>
      <td>-</td>
      <td>array</td>
      <td>vector\array\list</td>
      <td>对行或列依次调用FUN</td>
      <td>输入的arry必须2维及以上</td>
   </tr>
   <tr>
      <td>tapply</td>
      <td>tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)</td>
      <td>X为要计算的数据</td>
      <td>INDEX表示索引，如何分组</td>
      <td>FUN表示函数，对数据进行的操作</td>
      <td>simplify = TRUE)结果是向量，相反则是列表</td>
      <td>array</td>
      <td>vector\list</td>
      <td>对按index分组的数据依次调用FUN</td>
      <td></td>
   </tr>
   <tr>
      <td>sapply</td>
      <td>sapply(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE)</td>
      <td>X为要计算的数据</td>
      <td>FUN表示函数，对数据进行的操作</td>
      <td>simplify = array输出矩阵</td>
      <td>USE.NAMES如果为TRUE，如果X是字符，则使用X作为结果的名称</td>
      <td>list</td>
      <td>list\vector\matrix</td>
      <td>对list的每个元素调用FUN</td>
      <td></td>
   </tr>
   <tr>
      <td>mapply</td>
      <td>mapply(FUN, ..., MoreArgs = NULL, SIMPLIFY =TRUE,USE.NAMES = TRUE)</td>
      <td>FUN表示函数，对数据进行的操作</td>
      <td>…对上一操作的补充，比如fun是rep，第二个参数可以写times=</td>
      <td>MoreArgs = NULL其他的参数默认为没有</td>
      <td></td>
      <td>list</td>
      <td>list\vector\matrix</td>
      <td>在多个数据中，第一个元素组成的数组，第二个元素组成的……，依次调用FUN</td>
      <td>多变量版的sapply</td>
   </tr>
   <tr>
      <td>vapply</td>
      <td>vapply(X, FUN, FUN.VALUE, ..., USE.NAMES = TRUE)</td>
      <td>X为要计算的数据</td>
      <td>FUN表示函数，对数据进行的操作</td>
      <td></td>
      <td>USE.NAMES如果为TRUE，如果X是字符，则使用X作为结果的名称</td>
      <td>list</td>
      <td>list\vector\matrix</td>
      <td>递归调用FUN，出现新的list继续调用FUN</td>
      <td>递归版的sapply</td>
   </tr>
   <tr>
      <td></td>
   </tr>
</table>

#### 2. 在matrix中用apply函数取出一半以上的列大于0的行
幸蒙赐教，不胜感激。
```
> a <- c(1,-2,-3,5,1,-3,23,-12,-0.5,-0.7,11,6.1,7,-4,-5,-8,14,12,45,5,-1,9,2,1,-9)
> matrix(a,nrow=5)
     [,1]  [,2] [,3] [,4] [,5]
[1,]    1  -3.0 11.0   -8   -1
[2,]   -2  23.0  6.1   14    9
[3,]   -3 -12.0  7.0   12    2
[4,]    5  -0.5 -4.0   45    1
[5,]    1  -0.7 -5.0    5   -9
> x <- matrix(a,nrow=5)
> x[apply(x,1,
+         function(x)
+             {
+             length(x[x>0])>length(x)*0.5
+         }),]
     [,1]  [,2] [,3] [,4] [,5]
[1,]   -2  23.0  6.1   14    9
[2,]   -3 -12.0  7.0   12    2
[3,]    5  -0.5 -4.0   45    1
```
#### 3. 构造消费金额dataframe，用两种方法得到每人最贵的消费，并通过循环多次比较这两种方法用时长短
##### o	通过tapply函数
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
> tapply(expense,expense$name,max)
Error in tapply(expense, expense$name, max) : 参数的长度必需相同
```
按照`tapply`帮助文件中的示例:
>  contingency table from data.frame : array with named dimnames
```
tapply(warpbreaks$breaks, warpbreaks[,-1], sum)
tapply(warpbreaks$breaks, warpbreaks[, 3, drop = FALSE], sum)
```
由于数据框每一列有名字，则用`$`索引，第一个参数为要计算的区域，  
第二个参数为按某某分组，第三个是函数。困难在于，要计算的区域不是其中一列，  
是某几列，第一个参数用`expense$`表示不出来，我查阅了一些资料：
>R says that arguments must have the same lengths, say "we want to calculate the summary of all variable in iris along the factor Species": but R just can't do that because it does not know how to handle.
With the by function R dispatch a specific method for data frame class and then let the summary function works even if the length of the first argument (and the type too) are different.
```
bywork <- by(iris, iris$Species, summary )
bywork
iris$Species: setosa
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
 Min.   :4.300   Min.   :2.300   Min.   :1.000   Min.   :0.100   setosa    :50  
 1st Qu.:4.800   1st Qu.:3.200   1st Qu.:1.400   1st Qu.:0.200   versicolor: 0  
 Median :5.000   Median :3.400   Median :1.500   Median :0.200   virginica : 0  
 Mean   :5.006   Mean   :3.428   Mean   :1.462   Mean   :0.246                  
 3rd Qu.:5.200   3rd Qu.:3.675   3rd Qu.:1.575   3rd Qu.:0.300                  
 Max.   :5.800   Max.   :4.400   Max.   :1.900   Max.   :0.600                  
-------------------------------------------------------------- 
iris$Species: versicolor
  Sepal.Length    Sepal.Width     Petal.Length   Petal.Width          Species  
 Min.   :4.900   Min.   :2.000   Min.   :3.00   Min.   :1.000   setosa    : 0  
 1st Qu.:5.600   1st Qu.:2.525   1st Qu.:4.00   1st Qu.:1.200   versicolor:50  
 Median :5.900   Median :2.800   Median :4.35   Median :1.300   virginica : 0  
 Mean   :5.936   Mean   :2.770   Mean   :4.26   Mean   :1.326                  
 3rd Qu.:6.300   3rd Qu.:3.000   3rd Qu.:4.60   3rd Qu.:1.500                  
 Max.   :7.000   Max.   :3.400   Max.   :5.10   Max.   :1.800                  
-------------------------------------------------------------- 
iris$Species: virginica
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
 Min.   :4.900   Min.   :2.200   Min.   :4.500   Min.   :1.400   setosa    : 0  
 1st Qu.:6.225   1st Qu.:2.800   1st Qu.:5.100   1st Qu.:1.800   versicolor: 0  
 Median :6.500   Median :3.000   Median :5.550   Median :2.000   virginica :50  
 Mean   :6.588   Mean   :2.974   Mean   :5.552   Mean   :2.026                  
 3rd Qu.:6.900   3rd Qu.:3.175   3rd Qu.:5.875   3rd Qu.:2.300                  
 Max.   :7.900   Max.   :3.800   Max.   :6.900   Max.   :2.500
 ```
>it works indeed and the result is very surprising. It is an object of class by that along Species (say, for each of them) computes the summary of each variable.
[来源](http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega)

从上面可以看出，当要计算的区域比较复杂，恐怕用`tapply`算不出来，而`by`可以替代。但`by`要注意数据框，非数值型数据，会出错，要稍微处理一下。
```
> by(expense[,2:6],expense$name,max)
expense$name: Amy
[1] 3120
------------------------------------------------------------------ 
expense$name: Anne
[1] 2300
------------------------------------------------------------------ 
expense$name: Bob
[1] 2100
------------------------------------------------------------------ 
expense$name: Bridge
[1] 1480
------------------------------------------------------------------ 
expense$name: Hector
[1] 2112
------------------------------------------------------------------ 
expense$name: Jack
[1] 1780
------------------------------------------------------------------ 
expense$name: Marry
[1] 23400
```
##### o	通过apply
既然已经会了如何处理数据框非全数值型的问题，`apply`在这里也可以用。
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
> apply(expense[,2:6],1,max)
[1]  2300  3120 23400  2100  1480  2112  1780
```
##### o	通过dplyr
```
> by_name <- group_by(expense,name)
> mutate(by_name,max_expense=max(food,living,traveling,recreation,others))
Source: local data frame [7 x 7]
Groups: name [7]

    name  food living traveling recreation others per_max_expense
  <fctr> <dbl>  <dbl>     <dbl>      <dbl>  <dbl>           <dbl>
1   Anne   700   2300      1200       1200   1100            2300
2    Amy   950   3120       380       1300   2300            3120
3  Marry  1020   1200       890       1340  23400           23400
4    Bob   560   1400       770        340   2100            2100
5 Bridge   670   1480      1100        560    780            1480
6 Hector   980   2112      1230        780    560            2112
7   Jack   665   1780      1430        900   1000            1780
```
首先，要进行分组，选出每个人的最大消费，就应该按name分组 。  
不需要考虑行最大的行如何表示，只需运用分组功能，即可自行在组中计算。
然后运用mutate生成新变量。之后用`max`筛选最大值，  
要用`max(food,living,traveling,recreation,others)`表达最大值，  
因为`group_by`已经分过组，by name这个数据看起来和以前没什么区别，  
但是已经是分组的了，后续的操作在组中运行。
错误示例：
```
> mutate(by_name,per_max_expense=max(by_name[,2:6]))
Source: local data frame [7 x 7]
Groups: name [7]

    name  food living traveling recreation others per_max_expense
  <fctr> <dbl>  <dbl>     <dbl>      <dbl>  <dbl>           <dbl>
1   Anne   700   2300      1200       1200   1100           23400
2    Amy   950   3120       380       1300   2300           23400
3  Marry  1020   1200       890       1340  23400           23400
4    Bob   560   1400       770        340   2100           23400
5 Bridge   670   1480      1100        560    780           23400
6 Hector   980   2112      1230        780    560           23400
7   Jack   665   1780      1430        900   1000           23400
```
这样只选出了二到六列的最大值。前一步的分组形同虚设。

另外，虽没必要用`rowwise`，但也可走通。
```
expense %>% 
+     rowwise() %>% 
+     mutate(max_expense = max(food, living, traveling, recreation,others))
Source: local data frame [7 x 7]
Groups: <by row>

# A tibble: 7 × 7
    name  food living traveling recreation others max_expense
  <fctr> <dbl>  <dbl>     <dbl>      <dbl>  <dbl>       <dbl>
1   Anne   700   2300      1200       1200   1100        2300
2    Amy   950   3120       380       1300   2300        3120
3  Marry  1020   1200       890       1340  23400       23400
4    Bob   560   1400       770        340   2100        2100
5 Bridge   670   1480      1100        560    780        1480
6 Hector   980   2112      1230        780    560        2112
7   Jack   665   1780      1430        900   1000        1780
```
`rowwise`用于支持对每行的复杂操作，在输入数据时可以控制按行分组。根据帮助中例子的用法，第一行先写数据名，表示输入数据，第二行运用`rowwise`表示如下操作按照行进行，第三行写`mutate`具体的操作。
##### o	方法的选择
可以通过需要输出的模式来选择以上几种方法，需要直接生成在表里可以选`dplyr`，后续操作还能用大量的`%>%`，比较方便。
需要生成一行向量，可以选择`apply`系列，可用`cbind`将结果合在表里，进行后续的计算也很方便。
当然`by`结果输出的也不错，便于清楚地看到结果。但限制了后续的操作，这或许是`by`不如前两种常用的原因。
