Corelist:
https://docs.google.com/spreadsheets/d/1pEqbu_B3u7SAGYoLRkbHIC26slpm-p2At-ZIEZx-w2c/edit?usp=sharing 

Her bir dizaynı kendi içinde karşılaştırıp sonra sonuçları karşılaştırmak daha doğru olabilir.
Dataların açıklamaları not halinde verildi. Dizaynda dikkat edilmesi gerekenler belirtildi. 


1- DesignData1 değerlerinde interleaving yok bu yüzden Lnumber 1 olarak verilmiş durumda. 
   Bir switching periyotta simetrik gelen akım waveformunun yarısı kaydedildi. Tekrar ikiye bölmene gerek yok.
   ***Dikkat edilmesi gereken nokta: ilk 30 data max DC akım değeri için oluşturuldu (Vin=850A) ve inductor bu noktalar için tasarlanacak.
      İkinci 30 nokta için (max ripple oluşacağı Vin=900V, D=0.25) yeni dizayn gerekmiyor önceki inductor değerleri için loss hesabı yapılacak.
      Core loss artıp copper loss düşmesi durumu var ve toplam lossun çok değişmemesi bekleniyor. Karşılaştıması yapılacak.

2- DesignData2 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (Z interleaving)
   Simetrik olmadığı için tam switching waveform olarak verildi.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli.

3- DesignData3 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (Z interleaving)
   DesignData2 ripple değerleri yüksek olduğu için L iki katına çıkarıldı ve karşılaştırma için kullanılacak.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli.

4- DesignData4 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (Z interleaving)
   DesignData2 ripple değerleri yüksek olduğu için L dört katına çıkarıldı ve karşılaştırma için kullanılacak.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli

5- DesignData5 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (N interleaving)
   Simetrik olmadığı için tam switching waveform olarak verildi.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli.

6- DesignData6 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (N interleaving)
   DesignData5 ripple değerleri yüksek olduğu için L iki katına çıkarıldı ve karşılaştırma için kullanılacak.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli.

7- DesignData7 değerlerinde interleaving var bu yüzden Lnumber 4 olarak verilmiş durumda. (N interleaving)
   DesignData5 ripple değerleri yüksek olduğu için L dört katına çıkarıldı ve karşılaştırma için kullanılacak.
   ***Dizayn edilen inductor loss 4 ile çarpılacak.***
      Sadece data içinde yazan L değeri ve akıma göre dizayn yapmak yeterli.
