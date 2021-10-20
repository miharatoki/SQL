検索結果の加工
select文のみ、where以外にも修飾することができる
DISTINCT 　　　　検索結果から重複行を除外する
ORDER BY　　　　 検索結果の順序を並べ替える
OFFSET -FETCH　　検索結果から件数を限定して取得する
UNION           検索結果に他の検索結果を足し合わせる
EXCEPT          検索結果から他の検索結果を再引く
INTERSECT       検索結果と他の検索結果で重複する部分を取得する


DISTINCT
 データの種類を取得したいときに使う。食費、交際費、水道光熱費などの費目の詳細の一覧を見たい時など
 SELECT DISTNICT 費目
          FROM 家計簿 　　--費目列のデータを取得し、同じ費目の行は除外する(重複した最初の行は表示)

ORDER BY句
昇順はASC、降順はDESCを指定する。何も指定しない場合は昇順になる。
 SELECT *
   FROM 家計簿
  ORDER BY 出金額 DESC
複数の列を間まで区切って指定すると、最初の列で同じ値があったら次のカンマの条件で並び替える
SELECT *
   FROM 家計簿
   ORDER BY 出金額 DESC, 入金額 DESC　--主金額が同じデータがあった場合、そのデータの入金額を降順で並び替える
列名ではなく列番号で指定することもできる
SELECT *
   FROM 家計簿
   ORDER BY 1 DESC, 2 DESC  --この場合、SELECTで指定した列の順番で列番号が振られるため注意


OFFSET -FETCH句
 並び替えたデータのうち、数件だけ取得したい場合などで使用する
 SELECT *
   FROM 家計簿
  ORDER BY 出金額 DESC
  OFFSET 0 ROWS   --上から何件除外するのか
  FETCH NEXT 3 ROWS ONLY  --取得したい行数、この場合上から3件のデータを取得する

  SELECT *
   FROM 家計簿
  ORDER BY 出金額 DESC
  OFFSET ２ ROWS
  FETCH NEXT １ ROWS ONLY  --3件目のデータのみ取得する


集合演算子
　処理を高速化するために、過去のデータを別のテーブルへ移した時など、構造が似た複数のテーブルにSELECT文を送る際に使う。
　集合演算とは、SELECT文によって抽出した結果表を１つのデータの集合として捉え、足し合わせたり共通部分を探すといった演算をする仕組み。
  それぞれの列数とデータ型が一致していいないと集合演算は使えない。しかしそれさえあっていれば異なるテーブルや列でもひとまとめにできる。
  また、1つのテーブルから異なる条件で検索した結果を1つの結果表にまとめることができ、クエリ数を減らすことができる。

UNION演算子
　2つのSELECT文をUNIONで繋いで記述するとそれぞれの検索結果を足し合わせた結果が返される。和集合
　SELECT 文1
  UNION  (ALL)  --ALLというキーワードを付加すると、超副業を全てそのまま返す。デフォルトでは重複行は1行にまとめられる。
  SELECT 文2

  select 費目, 入金額,出金額 from 家計簿
  union
  select 費目, 入金額, 出金額 from 家計簿アーカイブ
  order by 2, 3, 1

EXCEPT演算子
 差集合を求める集合演算子。文1の結果から文2の結果を引く
 SELECT 文1
  EXCEPT  --重複行をまとめずにそのまま返す
  SELECT 文2


INTERSECT演算子
　積集合を求める集合演算子。共通部分を求める。
  SELECT 列名 FROM テーブル名
  INTERSECT (ALL)
  SELECT 列名 FROM テーブル名



演習問題
1-1　○
select *
  from 注文履歴
order by 注文番号, 注文枝番

1-2 ○
select 商品名
  from 注文履歴
 where 日付 >= '2018-01-01' and 日付 <= '2018-01-31'
order by 商品名　　　　　　　　

1-3　○
select 注文番号,注文枝番,注文金額
  from 注文履歴
 where 分類 = 1
 order by 注文金額
 offset 1 rows
 fetch next 3 rows ONLY

1-4　x
select 日付,商品名,単価,数量,注文金額
  from 注文履歴
 where 分類 = 3 and 注文枝番 > 1    ->  where 分類 = 1 and 数量 >= 2
 order by 日付, 数量 desc

1-5 x
select 分類,商品名,null,単価    -> distinctを入れる
  from 注文履歴
 where 分類 = 2
 union
select 分類,商品名,null,単価
  from 注文履歴
 where 分類 = 3
 union
select 分類,商品名,サイズ,単価
  from 注文履歴
 where 分類 = 1
 order by 分類, 商品名
