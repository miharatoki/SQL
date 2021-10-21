集計関数
SELECT文でのみ使用可能
普通の関数とは違い、行ごとに計算を行うのではなく、全ての行に一回の計算を行う。そのため、結果表は1行だけになる。
SUM => 指定した列を集計する
例：SUM(出金額)  SUM(出金額 *1.1)
MAX => 最大値
MIN => 最小値
AVG => 平均値
-------------
NULLを無視するが、全ての行がNULLの場合は結果表がNULLになる
SELECT AVG(COALESCE(出金額, 0)) 出金額の平均 FROM 家計簿 --出金額列のNULLを０に置き換えた上で平均値を求める

COUNT => 行数
例：COUNT(*) => 検索結果の行数 (NULLも含めてカウント)
　　COUNT(列) => 検索結果の指定列に関する行数 (NULLはカウントされない)
　　SELECT COUNT(DISTINCT 費目) FROM 家計簿 --重複指定いる値を除いた行数を取得できる


グループ化
集計前に、検索結果を指定した基準でまとまりに分けること
/* 費目ごとに合計数を集計する */
SELECT 費目, SUM(出金額) AS 費目別の出金額合計
  FROM 家計簿
GROUP BY 費目

SELECT グループ化する基準列, 集計関数
  FROM テーブル名
(WHERE) 
GROUP BY グループ化する基準列(複数列にすることで詳細なグループ化も条件を作れる)


HAVING句
集計結果表に対して絞り込む条件を指定できる。WHERE句は集計前の表に対してだったの対しHAVING句は集計した後の表に対して絞り込める
WHERE句では集計関数を使用できなかったが、HAVING句では使用できる。
SELECT 費目, SUM(出金額) AS 費目別の出金額合計
FROM 家計簿
GROUP BY 費目
HAVING SUM(出金額) > 0 --集計結果表の合計列が0以上の行のみ抽出


集計テーブル
　テーブルの集計結果をあらかじめ格納しておくテーブル
　定期的に集計し直して更新している


練習問題
6-1
1
SELECT SUM(降水量)AS 年間降水量, AVG(最高気温) AS 最高気温平均, AVG(最低気温)AS 指定気温平均
  FROM 都市別気象観測
2
SELECT SUM(降水量)AS 年間降水量, AVG(最高気温) AS 最高気温平均, AVG(最低気温)AS 指定気温平均
  FROM 都市別気象観測
 WHERE 都市名 = '東京'
3
SELECT 都市名, AVG(降水量), MIN(最高気温), MAX(最低気温)
  FROM 都市別気象観測
GROUP BY 都市名
4
SELECT 月, AVG(降水量), AVG(最高気温), AVG(最低気温)
  FROM 都市別気象観測
GROUP BY 月
5
SELECT 都市名, MAX(最高気温)
  FROM 都市別気象観測
GROUP BY 都市名
HAVING MAX(最高気温) >= 38
6
SELECT 都市名, MIN(最適温)
  FROM 都市別気象観測
GROUP BY 都市名
HAVING MIN(最低気温), <= -10

6-2
1
SELECT COUNT(退室)
  FROM 入退室管理
２
SELECT 社員名, COUNT(日付) AS 入室回数
  FROM 入退室管理
GROUP BY 社員名
ORDER BY 入室回数 DESC
３
SELECT CASE 事由区分 WHEN '1' THEN 'メンテナンス' WHEN '2' THEN 'リリース作業' WHEN '3' THEN '障害対応' WHEN '9' THEN 'その他' END AS 事由区分, COUNT(事由区分) AS 入室回数
  FROM 入退室管理
GROUP BY 事由区分
4
SELECT 社員名, COUNT(日付) AS 入室回数
  FROM 入退室管理
GROUP BY 社員名
HAVING COUNT(日付) > 10
5
SELECT 日付, COUNT(社員名) AS 対応社員数
  FROM 入退室管理
 WHERE 事由区分 = '3'
GROUP BY 日付

6-3
2,5