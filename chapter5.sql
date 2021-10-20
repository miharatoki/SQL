計算式の使用

SELECT文のすぐ後ろに指定するのが選択列リストといい、結果表にどのような列を表示するのか指定できる。
選択列リスト列名の他に計算式や固定値を指定することができる。
SELECT 出金額 　　　　　　--列名での指定
　　　  出金額+100       --計算式での指定（各行の出金額の値に+100された値が表示される）
　　　　'SQL'　　　　　   --固定値での指定（全ての行の値がSQLになる）
from 家計簿

INSERTやUPDATE文で計算式を使う
INSERT INTO 家計簿 (出金額)
     VALUES (1000 + 100)

UPDATE 家計簿
SET 　　出勤簿 = 出勤簿 + 100  --全ての行の出金額列に+100をする


代表的な演算子
日付 + 数値 　　日付を指定日数だけ進める
日付 - 数値   　日付を指定日数だけ戻す
日付 - 日数   　日付の差の日数を得る
文字列 || 文字列   文字列の連結をする

CASE演算子
 列の値や条件式を評価し、その結果に応じて好きな値に変換することができる。
構文１
CASE WHEN 値１ THEN 値１の時に返す値
     WHEN 値２ THEN 値２の時に返す値
     ELSE デフォルト値
END

SELECT 費目, 出金額,
CASE　　費目 WHEN '住居費'    THEN '固定費'
        　  WHEN '水道光熱費' THEN '固定費'
          　ELSE '変動費'　
/* caseからendまでが一つの選択列 */
END  AS 出費の分類 --列名を出費の分類
FROM 家計簿
WHERE 出金額 > 0

構文２
CASE WHEN 条件１ THEN 条件１の時に返す値
     WHEN 条件１ THEN 条件１の時に返す値
     ELSE デフォルト値
END

SELECT 費目, 出金額,
CASE　　費目 WHEN 入金額 < 5000   THEN 'お小遣い'
        　  WHEN 入金額 < 100000 THEN '一時収入'
          　ELSE '想定外の収入'
END  AS 出費の分類
FROM 家計簿
WHERE 入金額 > 0



関数
　呼び出し時に指定した引数に対して定められた処理を行い、結果（戻り値）に変換する
　ユーザーが自分で定義した関数をユーザー定義関数という。
　複数のSQL文をまとめてプログラムにしてDBMSに保存し、DB外から呼び出すことをストアドプシロージャという
　関数の名前（引数）
SELECT メモ, LENGTH (メモ) AS メモの長さ
 FROM 家計簿

関数は呼び出し後に戻り値に化けるので、関数の入子をすることができる。
例；LENGTH(TRIM('SQL  '))=> 3  -- TRIM=文字列の空白文字を削除する関数

TRIM  => 左右から空白を削除し亜文字列  --CHAR型の列だと、最大文字以下の文字列には自動で空白が追加されるので、そのデータを抽出する際などにTRIM関数を使う
LTRIM => 左から空白を削除し亜文字列
RTRIM => 右から空白を削除し亜文字列

REPLACE => 文字列を置換する。　REPLACE(置換対象の文字列, 置換前の部分文字列, 置換後の部分文字列)
例：REPLACE('コーヒーを購入した', '購入した', '買った') => 'コーヒーを買った'

SUBSTRING => 文字列の一部分だけを取り出す  SUBSTRING(文字列がある列, 抽出を開始する位置, 抽出する文字数)
例：SELECT * FROM 家計簿
   WHERE SUBSTRING(費目, 1, 3) LIKE '%費%' --費目列の1~3文字目に費が入っているデータのみ表示

CONCAT => 文字列を連結する
例：CONCAT(文字列, 文字列...)
select concat(費目, '：' , メモ) from 家計簿

ROUND => 指定桁で四捨五入する
例： ROUND(数値を表す列, 有効とする桁数)
SELECT 出金額, ROUND(出金額, -2) as 百円単位の出金額　--小数点以下方向へ＋なので指数側の桁数には-を使用
FROM 家計簿

TRUNC => 指定桁で切り捨てる
例：TRUNC(数値を表す列, 有効とする桁数)
SELECT 出金額, TRUNC(出金額, -2) as 百円単位の出金額
FROM 家計簿

CURRENT_DATE => 現在の日付を得る(YYYY-MM-DD)
CURRENT_TIME => 現在の時刻を得る(HH:MM:SS)

CAST => データ型を変更する
例：CAST（変換する値 AS 変換する型）
UPDATE 家計簿
SET    メモ = CONCAT(CAST(出金額 AS VARCHAR(10)), '円')
WHERE  出金額 > 0

COALESCE => 最初に登場するNULLではない値を返す
例：COALESCE(条件や式1,,条件や式2...)


練習問題
5-1
Aの計算
UPDATE 試験結果
   SET 午後1 = (80*4)-(86+68+91)
 WHERE 受験者ID = SW1046
Bの計算
UPDATE 試験結果
   SET 論述 = (68*4)-(65+53+70)
 WHERE 受験者ID = SW1350
Cの計算
UPDATE 試験結果
   SET 午前 = (56*4)-(59+56+36)
 WHERE 受験者ID = SW1877

SELECT 受験者ID AS 合格者ID
   FROM 試験結果
  WHERE 午前 >= 60 AND （午後1 + 午後2) >= 120 AND 論述 >= (午前+午後1+午後2+論述)/3

5-2
1
UPDATE 回答者
   SET 国名 = CASE SUBSTRING(TRIM(メールアドレス), LENGTH(TRIM(メールアドレス))-1, 2)
             WHEN 'jp' THEN '日本'
             WHEN 'uk' THEN 'イギリス'
             WHEN 'cn' THEN '中国'
             WHEN 'fr' THEN 'フランス'
             WHEN 'vn' THEN 'ベトナム'
             END

2
SELECT TRIM(メールアドレス) AS メールアドレス,
       CONCAT(CAST(SUBSTRING(年齢, 1, 1) AS VARCHAR(1)), '0代:', CASE 性別 WHEN 'M' THEN '男性' ELSE '女性' END) AS 属性
  FROM 回答者

5-3
1
UPDATE 受注
   SET 文字数 = LENGTH(REPLACE(文字, '　', ' '))

2
SELECT 受注日, 受注ID, LENGTH(REPLACE(文字, '　', ' ')) AS 文字数, CASE 書体コード WHEN '1' THEN 'ブロック体' WHEN '2' THEN '筆記体' WHEN '3' THEN '草書体' ELSE NULL END AS 書体名, 
       CASE 書体コード WHEN '1' THEN 100 WHEN '2' THEN 150 WHEN '3' 200 ELSE 200 END AS 単価, 
       CASE WHEN LENGTH(REPLACE(文字, '　', ' ')) > 10 THEN 500 WHEN LENGTH(REPLACE(文字, '　', ' ')) < 10 THEN 0 END AS 特別加工料
  FROM 受注

3
UPDATE 受注
   SET 文字 = REPLACE(文字, ' ', '★')
  WHERE 受注ID = '113'