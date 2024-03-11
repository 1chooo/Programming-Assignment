# -*- coding: utf-8 -*-
"""
Date: 2023/11/27
HW: 27
Author: 林群賀
Student Number: 109601003
"""

import numpy as np

location = np.array(["台北 - 桃園", "台北 - 新竹", "台北 - 台中", "台北 - 嘉義", "台北 - 高雄", "台北 - 花蓮"])
prices = np.array([44, 116, 241, 386, 544, 284])
people = np.array([35273, 21543, 12573, 31567, 52386, 44138])

q1_revenue = prices * people
print(q1_revenue)

train_data = {
    "台北 - 桃園": {"price":  44, "people": 35273},
    "台北 - 新竹": {"price": 116, "people": 21543},
    "台北 - 台中": {"price": 241, "people": 12573},
    "台北 - 嘉義": {"price": 386, "people": 31567},
    "台北 - 高雄": {"price": 544, "people": 52386},
    "台北 - 花蓮": {"price": 284, "people": 44138},
}

for location, info in train_data.items():
    revenue = info["price"] * info["people"]
    print(f"{location} 在 Q1 的營收為 {revenue} 元")
