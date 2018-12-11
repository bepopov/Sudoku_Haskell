module Sudoku where

import System.Random
import Types

-- Генерация ячеек
generateCells :: Int -> [[Cell]]
generateCells size = undefined

-- Генерация областей, в которых каждый value встречается ровно один раз
generateSquares :: Int -> Int -> [Square]
generateSquares = undefined

generateSudoku :: [Char] -> IO()
generateSudoku size = do
                        putStrLn ("Generation is in progress")
                        {- Запускается генерация ячеек -}
                        {- Отображение сгенерированной игры -}



--Генерация поля, в качестве параметра передается размер поля
generateValues:: Int -> [[Cell]]
generateValues 0 = []
generateValues size = (defineLineValues gameSize $take gameSize $drop ((gameSize-size)*3+ div (gameSize-size) 3) $ cycle [1..gameSize]) : generateValues(size - 1) 

--вспомогательная функция для generateValues, принимает размер поля и лист данных из которого генерировать ячейки
defineLineValues:: Int -> [Int] -> [Cell]
defineLineValues 0 _ = []
defineLineValues x xs = defineLineValues (x-1) xs ++ [Cell True (xs !! (x-1)) []]

--преобразование двумерного листа cell в лист их значений
--Пример запроса getListValuesFromCell $ generateValues 9
getListValuesFromCell:: [[Cell]] -> [[Int]]
getListValuesFromCell (x:[])= [getLineValuesFromCell x]
getListValuesFromCell (x:xs) = getLineValuesFromCell x : getListValuesFromCell xs

--вспомогательная функция для getLineValuesFromCell, принимает лист cells и преобразует его в лист интов
getLineValuesFromCell :: [Cell] -> [Int]
getLineValuesFromCell [] = []
getLineValuesFromCell (cell:xs) = value cell : getLineValuesFromCell xs


--Алгоритмы для перемешивания значений двумерного листа

--Транспонирование матрицы
transpose:: [[a]]-> [[a]]
transpose ([]:_) = []
transpose x = (map head x) : transpose (map tail x)

--Поменять две строки в пределах их района
swapRows:: [[a]] -> IO [[a]]
swapRows xs =do
                   district <- getRandom 0 2
                   x <-getRandom 1 3
                   y <- getRandomNoDublicate x 1 3
                   let numSwRows = ((3 *district)+x-1,(3 *district)+y -1)
                   let randI | fst numSwRows <= snd numSwRows = fst numSwRows
                             | fst numSwRows > snd numSwRows = snd numSwRows

                   let randJ | fst numSwRows <= snd numSwRows = snd numSwRows
                             | fst numSwRows > snd numSwRows = fst numSwRows
                   let elemI = xs !! randI
                   let elemJ = xs !! randJ
                   let left = take randI xs
                   let middle = take(randJ - randI - 1) (drop(randI + 1) xs)
                   let right = drop (randJ + 1) xs
                   let mas = left ++ [elemJ] ++ middle ++ [elemI] ++ right
                   return mas
                   
--Поменять два столбца в пределах их района		
swapColumns:: [[a]] ->IO [[a]]
swapColumns xs = do 
                   let transposes = transpose xs
                   swaps <- swapRows transposes
                   return (transpose swaps)

--поменять местами два района по строкам
--swapRowsArea:: [[a]] -> IO [[a]]
swapRowsArea xs = do
                    district1Num <- getRandom 0 2
                    district2Num <- getRandomNoDublicate district1Num 1 3
                    let ind1 | district1Num <= district2Num = district1Num
                             | district1Num > district2Num = district2Num

                    let ind2 | district1Num <= district2Num = district2Num
                             | district1Num > district2Num = district1Num

                    let district1 = getTripleFromArea 3 ind1 xs
                    let district2 = getTripleFromArea 3 ind2 xs
                    let left = take (ind1*3) xs
                    let middle = take((ind2 - ind1 - 1)*3) (drop((ind1+1)*3) xs)
                    let right = drop ((ind2+1)*3) xs
                    let mas = left ++ district2 ++ middle ++ district1 ++ right
                    return mas
                    
--count - количество элементов в Area, в нашем случае это 3
getTripleFromArea:: Int -> Int -> [[a]] -> [[a]]
getTripleFromArea 0 _ _ = []
getTripleFromArea count numberDistrict xs = elem : getTripleFromArea (count-1) numberDistrict xs where
                                              elem = xs !! ((numberDistrict*3)-count)

--В качестве value подаем ранее полученное значение, чтобы не появлялось одинаковых значений
getRandomNoDublicate:: Int -> Int -> Int -> IO Int
getRandomNoDublicate value begin end = do
                                         random <- getRandom begin end
                                         if value == random 
                                         then getRandomNoDublicate value begin end
                                         else
                                          return random
											   
											   
getRandom:: Int -> Int -> IO Int
getRandom begin end = do
         g <- newStdGen
         let a = fst (randomR (begin, end :: Int) g)
         return a


			
		 
