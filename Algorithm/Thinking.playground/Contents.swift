//: A UIKit based Playground for presenting user interface
  
import UIKit

//动态规划：记录所有叠加可能状态的map，根据map来求解
//问题：对于一组不同重量、不可分割的物品，我们需要选择一些装入背包，在满足背包最大重量限制的前提下，背包中物品总重量的最大值是多少呢. 提升:找出最优解具体方案
//思路: 找出状态累计方程, 记录所有的结果(这里可能会导致内存溢出, 可优化)
