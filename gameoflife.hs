cls :: IO ()
cls = putStr "\ESC[2J"
{-
Position of each alive cell is a pair of
positive integers where (1, 1) is
the top-left corner.
-}

type Pos = (Int, Int)

-- We represent the board as a list live positions.

type Board = [Pos]

{-
Display the the interface of game including empty and live cells on the screen. "0" means alive, "." means empty
-}

showcells b = putStrLn (strFullBoard 20 20 b)

isLive :: Board -> Pos -> Bool
isLive b p = elem p b


strFullBoard m n b = if m == 0 then getSeq 0 n b else (strFullBoard (m-1) n b)++getSeq (m-1) n b 
  where
   getSeq m n b = if n == 0 then (strCell (m,n) b)++"\n" else (strCell (m,n) b) ++ getSeq m (n-1) b  
     where 
      strCell p b = if isLive b p then " 0 " else " . "   
      



-- Return the neighbours

neighbs :: Pos -> [Pos]
neighbs (x,y) = map  wrapEdge [(x-1, y-1), (x,   y-1),
                               (x+1, y),   (x-1, y+1),
                               (x+1, y-1), (x-1, y),
                               (x,   y+1), (x-1, y+1)]
                where 
                  wrapEdge (x,y) = (((x-1) `mod` width) + 1, ((y-1) `mod` height) + 1)



-- number of live neighbours for a given cell

liveneighbs :: Board -> Pos -> Int
liveneighbs b = length . filter (isLive b) . neighbs


isEmpty :: Board -> Pos -> Bool
isEmpty b p = not (isLive b p)


{-
new cells are born because of three alive cells neighbors.
-}

birthsCell :: Board -> [Pos]
birthsCell b = [p | p <- rmduplicate (concat (map neighbs b)),
                     isEmpty b p,
                     liveneighbs b p == 3]
                     where
                      rmduplicate [] = []
                      rmduplicate (x:xs) = x : rmduplicate (filter (/= x) xs)

{-
living positions in a board that have
 2 or 3 alive neighbours.
-}

nextStillLive :: Board -> [Pos]
nextStillLive b = [p | p <- b, elem (liveneighbs b p) [2,3]]


{-
Next configuration including all live cells in the next step.
-}

nextConfiguration :: Board -> Board
nextConfiguration b = nextStillLive b ++ birthsCell b



isBoardEmpty :: Board -> Bool
isBoardEmpty b = and [isEmpty b p | p <- rmduplicate (concat (map neighbs b))]
                     where
                      rmduplicate [] = []
                      rmduplicate (x:xs) = x : rmduplicate (filter (/= x) xs)
                      



-- Main function

gameoflife :: Board -> IO ()
gameoflife b = if not (isBoardEmpty b) then
            do cls
               showcells b
               wait 1000000
               gameoflife (nextConfiguration b)
         else
            do cls
               putStrLn "Game is Over"
          where wait n = sequence_ [return () | _ <- [1..n]]


-- Example data of board with width and height
example :: Board
example = [(1, 1), (1, 2), (2, 2), (5, 1), (5, 2), (4, 2), (9, 10), (10, 10), (10, 11), (10, 20), (11, 20)]

-- Here we define the size of the game
width = 12
height = 12







