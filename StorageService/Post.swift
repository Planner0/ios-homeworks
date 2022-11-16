//
//  Post.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 30.03.2022.
//

import UIKit

public struct Post {
    public let author: String
    public let descript: String
    public let image: String
    public let likes: Int
    public let views: Int
}
let postFirst = Post(author: "Зоопарк", descript: "Правила жизни большой панды: если хочется спать — спи, если хочется есть — ешь, а если в вольере висит шина, то ее надо обязательно оторвать, — говорит сотрудник зоопарка. — И Жуи всегда следует этим трем правилам.", image: "panda", likes: 50, views: 100)
let postSecond = Post(author: "Hi-News.ru", descript: "После появления SpaceX Илона Маска космос стал всё больше интересовать человечество. Все эти планы по межпланетным экспедициям, колонизация красной планеты — чудеса, да и только. Давайте предположим, что будущее наступило, а фантастические рассказы стали реальностью. Вы вышли из дома и решили полететь на время карантина на Марс. Открываете навигатор и прокладываете маршрут до Марса в колонию Илона Маска. Как вам кажется, сколько придется лететь, чтобы туда добраться? Давайте разберёмся.", image: "redPlanet", likes: 10, views: 200)
let postThird = Post(author: "Кинопоиск", descript: "В одном трамвайном депо жили два трамвая - мать и сын. С раннего утра до позднего вечера они колесили по городу, наполняя его радостным перезвоном и бодрым стуком колес, и были счастливы. Но ничто в жизни не вечно.", image: "twoTrains", likes: 1000, views: 20000)
let postFourth = Post(author: "Radio Jazz", descript: "Джаз, как принято считать — «интеллектуальная» музыка. Не всем доступная. С высоким входным порогом. Известное противоречие: чтобы слушать джаз, нужно в нем разбираться, но чтобы разобрать — нужно знать, что именно слушать! Есть джазовые треки, которые цепляют, пленяют и не отпускают.Мы выбрали семь самых «заразных». Take 5, Song for My Father, My Favorite Things, Girl from Ipanema, Waltz for Debby, Autumn Leaves, So What.", image: "jazz", likes: 20, views: 50)
