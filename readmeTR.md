# Kullanıcı Dokümantasyonu: IO.Net Reset & Auto Restart

#### Bu doküman, io.net konteynırları için otomatik sıfırlama ve kontrol işlemlerini nasıl gerçekleştireceğini açıklar.

## Kullanım

### 1. Scripti Çalıştırma

Aşağıdaki komutu terminalimize yapıştıralım : 

<pre class="bash"><code>curl -o io.sh https://raw.githubusercontent.com/0xluen/io-net-Worker-Restart-Script/main/script.sh && chmod +x io.sh && ./io.sh

</code></pre>



### 2. Worker Komutu


![](image1.png)

* Bu adımda Worker oluştururken kullandığımız launch komutunu kullanacağız. Komuta Workers sekmesinden ilgili workerı seçerek ulaşabilirsiniz. 

![](image2.jpg)


### 3. Periyot Seçimi 

 ![](image3.png)


* Bu adımda çalışma periyodu seçiyoruz.
- 1. One-time reset (Tek seferlik yeniden başlatma)
- 2. Periodic reset with condition check (Conteiner durumlarını belli bir periyotta kontrol ederek yeniden başlatma)
- 3. Periodic reset at specified intervals (Belirli bir periyotta düzenli olarak yeniden başlatma)


### 4. Periyot Seçimi (Tek seferlik başlatma seçilmediyse)

##### Enter delay in seconds (default is 60):
* Sorusunu 60 saniye olarak bırakabilir veya restart işleminin gerçekleşmesini istediğiniz aralığı seçebilirsiniz.

   ![](image4.png)

