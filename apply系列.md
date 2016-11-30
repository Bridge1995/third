# *apply系列
#### 1. 列表对比apply, tapply, sapply, rapply, mapply
<table>
   <tr>
      <td>函数</td>
      <td>用法</td>
      <td>输入</td>
      <td>输出</td>
      <td>功能</td>
      <td>备注</td>
   </tr>
   <tr>
      <td>apply</td>
      <td>apply(X, MARGIN, FUN, ...)</td>
      <td>array</td>
      <td>vector\array\list</td>
      <td>对行或列依次调用FUN</td>
      <td>输入的arry必须2维及以上</td>
   </tr>
   <tr>
      <td>tapply</td>
      <td>tapply(X, INDEX, FUN)</td>
      <td>array</td>
      <td>vector\list</td>
      <td>对按index分组的数据依次调用FUN</td>
      <td></td>
   </tr>
   <tr>
      <td>sapply</td>
      <td>sapply(X, FUN, ..., simplify = TRUE）</td>
      <td>list</td>
      <td>list\vector\matrix</td>
      <td>对list的每个元素调用FUN</td>
      <td>simply=FALSE输出list</td>
   </tr>
   <tr>
      <td>mapply</td>
      <td>mapply(FUN,)</td>
      <td>list</td>
      <td>list\vector\matrix</td>
      <td>在多个数据中，第一个元素组成的数组，第二个元素组成的……，依次调用FUN</td>
      <td>多变量版的sapply</td>
   </tr>
   <tr>
      <td>vapply</td>
      <td>vapply(X, FUN）</td>
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
`apply`的基本用法是明白的，但是实在不会一半以上该怎么写。
只会取出所有列大于0的行和最大列大于0的行。至于怎么数每列大于0的个数，请求给一点提示。
```
y <- x[apply(x>0,1,all),] 
y <- x[apply(x>0,1,any),]
```
#### 3. 构造消费金额dataframe，用两种方法得到每人最贵的消费，并通过循环多次比较这两种方法用时长短
##### o	通过tapply函数
```
spending <- c(700,950,1020,560,670,980,665,2300,3120,1200,1400,1480,2112,1780,1200,380,890,770,1100,1230,1430,1200,1300,1340,340,560,780,900,1100,2300,23400,2100,780,560,1000)
> rnames <- c('Anne','Amy','Marry','Bob','Bridge','Hector','Jack')
> cnames <- c('food','living','traveling','recreation','others')
> consume1 <- matrix(spending,nrow = 7,ncol = 5,byrow = TRUE,dimnames = list(rnames,cnames))
> consume1
        food living traveling recreation others
Anne     700    950      1020        560    670
Amy      980    665      2300       3120   1200
Marry   1400   1480      2112       1780   1200
Bob      380    890       770       1100   1230
Bridge  1430   1200      1300       1340    340
Hector   560    780       900       1100   2300
Jack   23400   2100       780        560   1000
> tapply(consume1,cnames,max)
Error in tapply(consume1, cnames, max) : 参数的长度必需相同
```
按照道理，`tapply`是有分组功能的`apply`，应用于数组，`matrix`二维数组，应该可行，但未能成功。
###### 关于`by`
Usage  `by(data, INDICES, FUN, ..., simplify = TRUE)`，从用法可以看出，`by`和`tapply`很接近。是可以用在数据框上的`tapply`。
```
> consume2 <- data.frame(food,living,traveling,recreation,others)
> rnames <- c('Anne','Amy','Marry','Bob','Bridge','Hector','Jack')
> consume2
  food living traveling recreation others
1  700   2300      1200       1200   1100
2  950   3120       380       1300   2300
3 1020   1200       890       1340  23400
4  560   1400       770        340   2100
5  670   1480      1100        560    780
6  980   2112      1230        780    560
7  665   1780      1430        900   1000
> by(consume2,rnames,max)
rnames: Amy
[1] 3120
-------------------------------------------------------------------- 
rnames: Anne
[1] 2300
-------------------------------------------------------------------- 
rnames: Bob
[1] 2100
-------------------------------------------------------------------- 
rnames: Bridge
[1] 1480
-------------------------------------------------------------------- 
rnames: Hector
[1] 2112
-------------------------------------------------------------------- 
rnames: Jack
[1] 1780
-------------------------------------------------------------------- 
rnames: Marry
[1] 23400
```
##### o	通过dplyr
我希望通过mutate生成新的一列，用`max[]`计算出每列最大值，由于是每一列最值，因此想到了`for`循环。
```
> food <- c(700,950,1020,560,670,980,665)
> living <- c(2300,3120,1200,1400,1480,2112,1780)
> traveling <- c(1200,380,890,770,1100,1230,1430)
> recreation <- c(1200,1300,1340,340,560,780,900)
> others <- c(1100,2300,23400,2100,780,560,1000)
> name <- c('Anne','Amy','Marry','Bob','Bridge','Hector','Jack')
> expense <- data.frame(name,food,living,traveling,recreation,others)
> expense1 <- data.frame(food,living,traveling,recreation,others)
```
发现必须用在全是数值的数据框上，因此先将名字去掉，在expense1数据集上操作。
```
> mutate(expense1,max(expense1[1,]))
  food living traveling recreation others max(expense1[1, ])
1  700   2300      1200       1200   1100               2300
2  950   3120       380       1300   2300               2300
3 1020   1200       890       1340  23400               2300
4  560   1400       770        340   2100               2300
5  670   1480      1100        560    780               2300
6  980   2112      1230        780    560               2300
7  665   1780      1430        900   1000               2300
```
发现`max(expense1[1,]`用在这里是对的，但要遍历每一行，想到了循环结构。
先取行数
```
> n <- dim(expense1)[n] 
> n
[1] 7
```
然后取最大值
```
> for(i in 1:n)
+     expense2 <- mutate(expense1,max(expense1[i,]))
> expense2
  food living traveling recreation others max(expense1[i, ])
1  700   2300      1200       1200   1100               1780
2  950   3120       380       1300   2300               1780
3 1020   1200       890       1340  23400               1780
4  560   1400       770        340   2100               1780
5  670   1480      1100        560    780               1780
6  980   2112      1230        780    560               1780
7  665   1780      1430        900   1000               1780
```
但只取了最后一行的最大值。或许整体的思路就是有问题的，或许`for`用在这里是不合适的。但是，我想不到别的办法。

