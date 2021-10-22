SELECT文をネストする
SQL文部品として登場するSQL文
副問い合わせ、副照会、サブクエリという

単一行副問い合わせ
　1行1列の値になる副問い合わせ(スカラー)
　SELECTの選択列リスト、FROM句、SET句、WHERE句などで使用
SELECT 費目, 出金額
  FROM 家計簿
 WHERE 出金額 = (SELECT MAX(出金額) FROM 家計簿)

複数行副問い合わせ
　複数の行を持つ1列になる服問い合わせ（ベクター）
　複数の値を列挙する場所に記述する。
　IN, ANY, ALL演算子などで使用する。
SELECT *
  FROM 家計簿アーカイブ
 WHERE 費目 IN (SELECT DISTINCT 費目 FROM 家計簿)  --('食費', '水道光熱費', '共用娯楽費', '給料')と同じ結果

服問い合わせの結果にNULLが含まれると、正しいデータを抽出できない可能性がるので、NULLを除外する記述をする必要がある。
SELECT + FROM 家計簿アーカイブ WHERE 費目 IN (SELECT 費目 FROM 家計簿 WHERE 費目 IN NOT NULL) 
　　　　　　　　　　　　　　　　　　　　　　　　　(SELECT COALESCE(費目, '不明') FROM 家計簿)


表形式の副問い合わせ
 複数行複数列のになる副問い合わせ
 FROM句、INSERT文などに記述する

 FROM句
 SELECT SUM(SUB.出金額) AS 出金額合計　-- SUB.で名前をつけた表の列を指定している
  FROM  (SELECT 日付, 費目, 出金額 FROM 家計簿
         UNION
         SELECT 日付, 費目, 出金額 FROM 家計簿アーカイブ WHERE 日付 >= '2018-01-01' AND 日付 <= '2018-01-31') AS SUB -- 服問い合わせで作成される表に名前をつける

 INSERT文(厳密にはINSERT文の特殊構文)
 INSERT INTO 家計簿集計 (費目, 合計, 平均, 回数)
 SELECT 費目, SUM(出金額), AVG(出金額), 0　VALUESに相当する箇所を副問い合わせで表形式の一行ずつDE表している
   FROM 家計簿
  WHERE 出金額 > 0
  GROUP BY 費目


相関副問い合わせ
/* 家計簿テーブルの費目が家計簿集計テーブルにもあったら、家計簿集計テーブルからその費目と合計を取得する　*/
SELECT 費目, 合計 FROM 家計簿集計
 WHERE EXISTS  --EXISTS演算子は、副問い合わせの結果が存在するかを判定し、存在するとTRUEになる。 NOT EXISTSで、存在しないことを判定できる
 (SELECT * FROM 家計簿 WHERE 家計簿.費目 = 家計簿集計.費目) 


練習問題
7-1
(A)単一行副問い合わせ (B)SELECT (C)SET (D)複数 (E)1 (F)複数行1列 (G)ANY (H)ALL (I)FROM (J)表 (K)INSERT

7-2
1
副問い合わせ
|レンタル日数|
| ----     |
|3         |

全体
|金額  |
|---  |
|25200|

2
副問い合わせ
|車種コード|
| ----     |
|S01    |
|E01    |
|S02    |

全体
|車種コード|車種名|
|---     | ---  |
|S01     |軽自動車|
|E01     |エコカー|
|S02     |ハッチバック|

3
副問い合わせ
|車種コード|日数|
|---     | ---|
|S02     |6   |
|S01     |3   |
|E01     |3   |

全体
|合計日数|車種数|
|---     | ---|
|12      |3   |

7-3
1
INSERT INTO 頭数集計 (飼育県, 頭数)
 SELECT 飼育県, COUNT(*)
   FROM 個体識別
  GROUP BY 飼育県

2
SELECT 飼育県, 個体識別番号, CASE 雌雄コード WHEN '1' THEN '雄' WHEN '2' THEN '雌' END AS 雌雄
  FROM 個体識別
 WHERE 飼育県 IN (SELECT 飼育県
                   FROM 頭数集計
                  ORDER BY 頭数 DESC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
                )

3
SELECT 個体識別番号, CASE 品種コード WHEN '01' THEN '乳用種' WHEN '02' THEN '肉用種' WHEN '03' THEN '交雑種' END AS 品種, 出生日, 母牛番号
  FROM 個体識別
 WHERE 母牛番号 IN (SELECT 個体識別番号
				      FROM 個体識別
				     WHERE 品種コード = '01'
			        )