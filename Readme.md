# ImageFilttering

Instagramみたいな画像処理フィルタをCで書いて、あとは適当にUIIamgeに変換してiPhoneに載せるなり、Bitmapに変換してAndroidに載せるなりを想定しています

## データ形式
画像はunsigned charの配列を扱います。RGBAの4チャンネルを想定しています。

## 実装済みのメソッド

### LUT変換
トーンカーブ変換とも。ある入力値をあらかじめ決めておいたテーブルに基づいて変換する

使い方
```
int lut[3][256];
loadLookUpTable(lut); // 色変換テーブルの読み出し
lut_convert(src_buf, dst_buf, height, width, lut); // LUT変換
```

(LUT変換の例)[sample1.png]