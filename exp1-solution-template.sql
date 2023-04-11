-- 姓名：黄俊祥
-- 学号：205220027
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1
SELECT count(*) as speciesCount FROM Species WHERE description LIKE '%this%';
-- END Q1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2
SELECT a.username,sum(Power)as totalPhonemonPower FROM Player a,Phonemon b
WHERE (a.username="Cook" or a.username="Hughes") AND (a.id=b.player) GROUP BY a.username;
-- END Q2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
SELECT Team.title, count(*) as numberOfPlayers 
FROM Player ,Team WHERE Player.team = Team.id GROUP BY Team.title ORDER BY count(*) DESC;

-- END Q3

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
SELECT Species.id as idSpecies , Species.title From Species , Type 
WHERE (Type.id = Species.type1 or Type.id = Species.type2) and Type.title ='Grass';
-- END Q4

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
SELECT id as idPlayer,username FROM Player WHERE id NOT IN
(
	SELECT player From Purchase a Where EXISTS
	(
		SELECT * FROM Item b WHERE a.Item = b.id and b.type = 'F'
	)
);
-- END Q5

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
SELECT level, sum(A.res) as totalAmountSpentByAllPlayersAtLevel FROM (SELECT B.player, sum(B.total) as res 
FROM (SELECT player,b.price * a.quantity as total FROM Purchase a,Item b WHERE a.item = b.id ) 
B GROUP BY B.Player) A , Player WHERE A.player = Player.id  GROUP BY level ORDER BY sum(A.res) DESC;
-- END Q6

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
SELECT item ,B.title,total as numTimesPurchased FROM (SELECT item ,count(player)as total FROM Purchase GROUP BY item) as A, 
Item  B WHERE item = B.id AND  A.total >= ALL (
	SELECT count(player) FROM Purchase GROUP BY item
);
             
-- END Q7

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8
SELECT Player.id,Player.username,L.sum_food as numberDistinctFoodItemsPurchased
FROM (SELECT player,count(player) as total FROM 
(SELECT  DISTINCT B.id,player,B.title FROM Purchase A , Item B WHERE A.item = B.id and B.type ='F' ) Q 
GROUP BY player) P ,(SELECT type,count(DISTINCT id) as sum_food FROM Item WHERE Item.type ='F'GROUP BY type) L,
Player WHERE  P.total = L.sum_food and Player.id = P.player;
-- END Q8

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
SELECT numberOfPhonemonPairs,distanceX  FROM 
(
SELECT count(Q.a) as  numberOfPhonemonPairs,Q.distance as distanceX 
FROM (SELECT A.id as a, B.id as b , A.id + B.id as new_id,
ROUND(SQRT(POWER(A.latitude-B.latitude,2) +POWER(A.longitude-B.longitude,2))*100,2)  as distance
FROM phonemon A, Phonemon B 
WHERE  A.id < B.id ) Q GROUP BY Q.distance
) Table1 
WHERE distanceX <= ALL
(
SELECT Q.distance as distanceX 
FROM (SELECT A.id as a, B.id as b , A.id + B.id as new_id,
ROUND(SQRT(POWER(A.latitude-B.latitude,2) + POWER(A.longitude-B.longitude,2))*100,2)  as distance
FROM phonemon A, Phonemon B 
WHERE  A.id < B.id ) Q GROUP BY Q.distance
);
-- END Q9

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
SELECT A.username,B.title as typeTitle
FROM Player A,Type B WHERE not exists
(SELECT* FROM Species C 
WHERE B.id in(C.type1,C.type2) AND not exists(
SELECT*FROM phonemon P WHERE A.id=P.player AND P.species=C.id));
-- END Q10