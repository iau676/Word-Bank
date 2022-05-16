//
//  WordBrain.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import Foundation
import UIKit
import CoreData

struct WordBrain {
    
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    
    var questionNumber = 0
    var changedQuestionNumber = 0
    var selectedSegmentIndex = 0
    var onlyHereNumber = 0
    var answer = 0
    var firstFalseIndex = -1
    
    var rightOnce = [Int]()
    var rightOnceBool = [Bool]()
    var arrayForResultViewENG = [String]()
    var arrayForResultViewTR = [String]()
    var isWordAddedToHardWords = 0
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var HardItemArray = [HardItem]()
    var quizCoreDataArray = [AddedList]()
    
    var itemArray = [Item]()
    
    let quiz = [
    
        Word(e: "hi", t: "merhaba, selam"),
        Word(e: "thank you", t: "teşekkürler, teşekkür ederim"),
        Word(e: "yes", t: "evet"),
        Word(e: "no", t: "hayır "),
        Word(e: "please", t: "lütfen"),
        Word(e: "okay", t: "tamam, peki"),
        Word(e: "good morning", t: "günaydın"),
        Word(e: "good night", t: "iyi geceler"),
        Word(e: "goodbye", t: "hoşçakal, güle güle"),
        Word(e: "how", t: "nasıl"),
        Word(e: "you", t: "sen, siz, seni, sizi"),
        Word(e: "how are you?", t: "nasılsın?"),
        Word(e: "I", t: "ben"),
        Word(e: "very", t: "çok"),
        Word(e: "very well", t: "çok iyi"),
        Word(e: "what", t: "ne"),
        Word(e: "name", t: "ad, isim"),
        Word(e: "your", t: "senin, sizin"),
        Word(e: "my", t: "benim"),
        Word(e: "January", t: "Ocak"),
        Word(e: "February", t: "Şubat"),
        Word(e: "March", t: "Mart"),
        Word(e: "April", t: "Nisan"),
        Word(e: "May", t: "Mayıs"),
        Word(e: "June", t: "Haziran"),
        Word(e: "July", t: "Temmuz"),
        Word(e: "August", t: "Ağustos"),
        Word(e: "September", t: "Eylül"),
        Word(e: "October", t: "Ekim"),
        Word(e: "November", t: "Kasım"),
        Word(e: "December", t: "Aralık"),
        Word(e: "happy", t: "mutlu"),
        Word(e: "sad", t: "mutsuz"),
        Word(e: "angry", t: "kızgın"),
        Word(e: "wrong", t: "yanılmış (olmak), haksız (olmak)"),
        Word(e: "right", t: "doğru, haklı, sağ (yön)"),
        Word(e: "tired", t: "yorgun"),
        Word(e: "sick", t: "hasta"),
        Word(e: "hungry", t: "(karnı) aç"),
        Word(e: "thirsty", t: "susuz"),
        Word(e: "food", t: "yiyecek"),
        Word(e: "bread", t: "ekmek"),
        Word(e: "pasta", t: "makarna"),
        Word(e: "rice", t: "pirinç"),
        Word(e: "potato", t: "patates"),
        Word(e: "vegetable", t: "sebze"),
        Word(e: "fruit", t: "meyve"),
        Word(e: "meat", t: "et"),
        Word(e: "salad", t: "salata"),
        Word(e: "apple", t: "elma"),
        Word(e: "banana", t: "muz"),
        Word(e: "orange", t: "portakal"),
        Word(e: "lemon", t: "limon"),
        Word(e: "snack", t: "atıştırmalık"),
        Word(e: "soup", t: "çorba"),
        Word(e: "egg", t: "yumurta"),
        Word(e: "cheese", t: "peynir"),
        Word(e: "chicken", t: "tavuk eti"),
        Word(e: "pork", t: "domuz eti"),
        Word(e: "beef", t: "kırmızı et"),
        Word(e: "fish", t: "balık eti"),
        Word(e: "water", t: "su"),
        Word(e: "coffee", t: "kahve"),
        Word(e: "tea", t: "çay"),
        Word(e: "beer", t: "bira"),
        Word(e: "wine", t: "şarap"),
        Word(e: "milk", t: "süt"),
        Word(e: "juice", t: "meyve suyu"),
        Word(e: "sauce", t: "sos"),
        Word(e: "butter", t: "tereyağı"),
        Word(e: "it", t: "o, bu"),
        Word(e: "like", t: "sevmek"),
        Word(e: "delicious", t: "lezzetli"),
        Word(e: "disgusting", t: "iğrenç"),
        Word(e: "awesome", t: "harika"),
        Word(e: "do", t: "yapmak"),
        Word(e: "not", t: "değil, -me, -ma"),
        Word(e: "and", t: "ve"),
        Word(e: "English", t: "İngilizce, İngiliz"),
        Word(e: "British", t: "Britanyalı"),
        Word(e: "American", t: "Amerikan, Amerikalı"),
        Word(e: "Turkish", t: "Türkçe, Türk"),
        Word(e: "number", t: "sayı, numara"),
        Word(e: "phone", t: "telefon"),
        Word(e: "phone number", t: "telefon numarası"),
        Word(e: "zero", t: "sıfır, 0"),
        Word(e: "one", t: "bir, 1"),
        Word(e: "two", t: "iki, 2"),
        Word(e: "three", t: "üç, 3"),
        Word(e: "four", t: "dört, 4"),
        Word(e: "five", t: "beş, 5"),
        Word(e: "six", t: "altı, 6"),
        Word(e: "seven", t: "yedi, 7"),
        Word(e: "eight", t: "sekiz, 8"),
        Word(e: "nine", t: "dokuz, 9"),
        Word(e: "ten", t: "on, 10"),
        Word(e: "restaurant", t: "restoran"),
        Word(e: "table", t: "masa"),
        Word(e: "menu", t: "menü"),
        Word(e: "bill", t: "hesap"),
        Word(e: "knife", t: "bıçak"),
        Word(e: "fork", t: "çatal"),
        Word(e: "spoon", t: "kaşık"),
        Word(e: "can", t: "-ebilmek"),
        Word(e: "go", t: "gitmek, çıkmak"),
        Word(e: "have", t: "var, sahip olmak"),
        Word(e: "order", t: "sipariş vermek"),
        Word(e: "eat", t: "yemek"),
        Word(e: "drink", t: "içmek"),
        Word(e: "ready", t: "hazır"),
        Word(e: "the", t: "-e, -i, -u, -ü (en başta değilse)"),
        Word(e: "for", t: "için"),
        Word(e: "think", t: "düşünmek"),
        Word(e: "be", t: "olmak"),
        Word(e: "wonderful", t: "harika, güzel"),
        Word(e: "beautiful", t: "güzel"),
        Word(e: "strong", t: "güçlü"),
        Word(e: "weak", t: "güçsüz"),
        Word(e: "fat", t: "şişman"),
        Word(e: "thin", t: "zayıf"),
        Word(e: "nice", t: "hoş, güzel"),
        Word(e: "ugly", t: "çirkin"),
        Word(e: "cool", t: "havalı"),
        Word(e: "big", t: "büyük"),
        Word(e: "short", t: "kısa"),
        Word(e: "small", t: "küçük"),
        Word(e: "long", t: "uzun"),
        Word(e: "too", t: "fazla, de, da, çok"),
        Word(e: "how wonderful", t: "ne harika"),
        Word(e: "need", t: "ihtiyaç, ihtiyacı olmak"),
        Word(e: "help", t: "yardım"),
        Word(e: "say", t: "söylemek, demek"),
        Word(e: "know", t: "bilmek, tanımak"),
        Word(e: "understand", t: "anlamak"),
        Word(e: "too", t: "ben de (olumlu)"),
        Word(e: "neither", t: "ben de (olumsuz)"),
        Word(e: "meet", t: "buluşmak, tanışmak, görüşmek"),
        Word(e: "great", t: "müthiş"),
        Word(e: "here", t: "burada, burası"),
        Word(e: "here you go", t: "buyrun"),
        Word(e: "welcome", t: "hoşgeldiniz!"),
        Word(e: "luck", t: "şans"),
        Word(e: "good luck", t: "iyi şanslar"),
        Word(e: "the United States", t: "Amerika Birleşik Devletleri, Amerika"),
        Word(e: "Turkey", t: "Türkiye"),
        Word(e: "England", t: "İngiltere"),
        Word(e: "speak", t: "konuşmak, (dil) bilmek"),
        Word(e: "a little", t: "azıcık, biraz"),
        Word(e: "of course", t: "tabii ki"),
        Word(e: "glass", t: "bardak"),
        Word(e: "cup", t: "fincan"),
        Word(e: "bottle", t: "şişe"),
        Word(e: "latte", t: "latte"),
        Word(e: "starter", t: "aperatif"),
        Word(e: "main course", t: "ana yemek"),
        Word(e: "dessert", t: "tatlı"),
        Word(e: "some", t: "biraz, bazı (olumlu), birkaç"),
        Word(e: "any", t: "hiç (olumsuz ve soru)"),
        Word(e: "something", t: "bir şey (olumlu)"),
        Word(e: "anything", t: "hiçbir şey (olumsuz ve soru)"),
        Word(e: "or", t: "veya, ya da, yoksa"),
        Word(e: "eleven", t: "on bir, 11"),
        Word(e: "twelve", t: "on iki, 12"),
        Word(e: "thirteen", t: "on üç, 13"),
        Word(e: "fourteen", t: "on dört, 14"),
        Word(e: "fifteen", t: "on beş, 15"),
        Word(e: "sixteen", t: "on altı, 16"),
        Word(e: "seventeen", t: "on yedi, 17"),
        Word(e: "eighteen", t: "on sekiz, 18"),
        Word(e: "nineteen", t: "on dokuz, 19"),
        Word(e: "twenty", t: "yirmi, 20"),
        Word(e: "thing", t: "şey"),
        Word(e: "market", t: "market"),
        Word(e: "pharmacy", t: "eczane"),
        Word(e: "kiosk", t: "büfe"),
        Word(e: "people", t: "insanlar"),
        Word(e: "shop", t: "market, mağaza"),
        Word(e: "supermarket", t: "süpermarket"),
        Word(e: "car", t: "araba"),
        Word(e: "taxi", t: "taksi"),
        Word(e: "bank", t: "banka"),
        Word(e: "book", t: "kitap"),
        Word(e: "bookshop", t: "kitapçı"),
        Word(e: "customer", t: "müşteri"),
        Word(e: "want", t: "istemek"),
        Word(e: "buy", t: "satın almak"),
        Word(e: "sell", t: "satmak"),
        Word(e: "pay", t: "ödemek"),
        Word(e: "go shopping", t: "alışverişe gitmek"),
        Word(e: "there", t: "orada, var"),
        Word(e: "there is", t: "var (tekil)"),
        Word(e: "there are", t: "var (çoğul)"),
        Word(e: "many", t: "birçok (sayılabilir isimlerle)"),
        Word(e: "few", t: "birkaç"),
        Word(e: "much", t: "çok (sayılamayan isimlerle)"),
        Word(e: "for me", t: "benim için"),
        Word(e: "for you", t: "senin için"),
        Word(e: "drink", t: "içecek"),
        Word(e: "favourite", t: "en sevilen"),
        Word(e: "this", t: "bu"),
        Word(e: "that", t: "şu, o, bu, şunu, onu, bunu"),
        Word(e: "all", t: "bütün, hepsi"),
        Word(e: "actually", t: "aslında"),
        Word(e: "family", t: "aile"),
        Word(e: "mum", t: "anne"),
        Word(e: "dad", t: "baba"),
        Word(e: "parent", t: "anne-baba, ebeveyn"),
        Word(e: "sister", t: "kız kardeş"),
        Word(e: "brother", t: "erkek kardeş"),
        Word(e: "grandpa", t: "dede"),
        Word(e: "grandma", t: "anneanne, babaanne"),
        Word(e: "grandparent", t: "büyükbaba-büyükanne"),
        Word(e: "son", t: "erkek çocuk, oğul"),
        Word(e: "daughter", t: "kız çocuk"),
        Word(e: "friend", t: "arkadaş"),
        Word(e: "boyfriend", t: "erkek arkadaş"),
        Word(e: "girlfriend", t: "kız arkadaş"),
        Word(e: "husband", t: "koca, eş"),
        Word(e: "wife", t: "karı, eş"),
        Word(e: "kid", t: "çocuk"),
        Word(e: "person", t: "insan, kişi"),
        Word(e: "job", t: "iş"),
        Word(e: "school", t: "okul"),
        Word(e: "office", t: "ofis"),
        Word(e: "work", t: "işte çalışmak, işe yaramak"),
        Word(e: "who", t: "kim, -an"),
        Word(e: "in", t: "-da, -de, içinde"),
        Word(e: "colour", t: "renk"),
        Word(e: "red", t: "kırmızı"),
        Word(e: "blue", t: "mavi"),
        Word(e: "yellow", t: "sarı"),
        Word(e: "green", t: "yeşil"),
        Word(e: "black", t: "siyah"),
        Word(e: "pink", t: "pembe"),
        Word(e: "purple", t: "mor"),
        Word(e: "white", t: "beyaz"),
        Word(e: "orange", t: "turuncu"),
        Word(e: "brown", t: "kahverengi"),
        Word(e: "grey", t: "gri"),
        Word(e: "light", t: "açık, hafif, ışık"),
        Word(e: "dark", t: "koyu, karanlık"),
        Word(e: "light blue", t: "açık mavi"),
        Word(e: "dark red", t: "koyu kırmızı"),
        Word(e: "hospital", t: "hastane"),
        Word(e: "here it is", t: "burada"),
        Word(e: "just a little", t: "sadece biraz"),
        Word(e: "enough", t: "yeter, yeterince"),
        Word(e: "possible", t: "mümkün"),
        Word(e: "impossible", t: "imkansız"),
        Word(e: "shame", t: "ayıp"),
        Word(e: "clothes", t: "kıyafet"),
        Word(e: "trousers", t: "pantolon"),
        Word(e: "shirt", t: "gömlek"),
        Word(e: "skirt", t: "etek"),
        Word(e: "dress", t: "elbise"),
        Word(e: "shorts", t: "şort"),
        Word(e: "coat", t: "palto"),
        Word(e: "jacket", t: "mont"),
        Word(e: "jumper", t: "kazak"),
        Word(e: "scarf", t: "atkı, şal"),
        Word(e: "hat", t: "şapka"),
        Word(e: "suit", t: "takım elbise"),
        Word(e: "socks", t: "çorap"),
        Word(e: "shoes", t: "ayakkabı"),
        Word(e: "slippers", t: "terlik"),
        Word(e: "boots", t: "çizme"),
        Word(e: "trainers", t: "spor ayakkabı"),
        Word(e: "gloves", t: "eldiven"),
        Word(e: "pants", t: "külot"),
        Word(e: "umbrella", t: "şemsiye"),
        Word(e: "bag", t: "çanta"),
        Word(e: "wallet", t: "cüzdan"),
        Word(e: "pee", t: "çiş yapmak, işemek"),
        Word(e: "have to", t: "gerekiyor, -meli, -malı"),
        Word(e: "new", t: "yeni"),
        Word(e: "old", t: "yaşlı"),
        Word(e: "closed", t: "kapalı"),
        Word(e: "open", t: "açık"),
        Word(e: "nuts", t: "çerez, fındık-fıstık"),
        Word(e: "sweets", t: "tatlı"),
        Word(e: "chocolate", t: "çikolata"),
        Word(e: "cake", t: "pasta, kek"),
        Word(e: "pizza", t: "pizza"),
        Word(e: "sugar", t: "şeker"),
        Word(e: "salt", t: "tuz"),
        Word(e: "pepper", t: "karabiber"),
        Word(e: "good", t: "iyi"),
        Word(e: "bad", t: "kötü"),
        Word(e: "vegetarian", t: "vejetaryen"),
        Word(e: "hot", t: "sıcak, acı"),
        Word(e: "cold", t: "soğuk"),
        Word(e: "allergic", t: "alerjik"),
        Word(e: "addicted", t: "bağımlı"),
        Word(e: "human", t: "insan"),
        Word(e: "animal", t: "hayvan"),
        Word(e: "dog", t: "köpek"),
        Word(e: "cat", t: "kedi"),
        Word(e: "bird", t: "kuş"),
        Word(e: "cow", t: "inek"),
        Word(e: "pig", t: "domuz"),
        Word(e: "chicken", t: "tavuk"),
        Word(e: "fish", t: "balık"),
        Word(e: "rabbit", t: "tavşan"),
        Word(e: "snake", t: "yılan"),
        Word(e: "lion", t: "aslan"),
        Word(e: "elephant", t: "fil"),
        Word(e: "horse", t: "at"),
        Word(e: "sheep", t: "koyun"),
        Word(e: "monkey", t: "maymun"),
        Word(e: "puppy", t: "yavru köpek"),
        Word(e: "kitten", t: "yavru kedi"),
        Word(e: "giraffe", t: "zürafa"),
        Word(e: "donkey", t: "eşek"),
        Word(e: "mouse", t: "fare"),
        Word(e: "loyal", t: "sadık"),
        Word(e: "brave", t: "cesur"),
        Word(e: "clever", t: "zeki"),
        Word(e: "stupid", t: "aptal"),
        Word(e: "free", t: "özgür"),
        Word(e: "tall", t: "uzun, yüksek"),
        Word(e: "quiet", t: "sessiz"),
        Word(e: "cute", t: "sevimli"),
        Word(e: "day", t: "gün"),
        Word(e: "week", t: "hafta"),
        Word(e: "month", t: "ay"),
        Word(e: "year", t: "yıl"),
        Word(e: "young", t: "genç"),
        Word(e: "flat", t: "daire"),
        Word(e: "house", t: "ev"),
        Word(e: "London", t: "Londra"),
        Word(e: "Istanbul", t: "Istanbul"),
        Word(e: "Ankara", t: "Ankara"),
        Word(e: "live", t: "yaşamak, (bir şehirde) oturmak"),
        Word(e: "too much", t: "çok fazla (sayılamayan), fazla"),
        Word(e: "always", t: "her zaman, hep"),
        Word(e: "never", t: "hiç, asla, hiçbir zaman"),
        Word(e: "why", t: "neden"),
        Word(e: "because", t: "çünkü"),
        Word(e: "so", t: "bu sayede, yani, o kadar, öyle"),
        Word(e: "thirty", t: "otuz, 30"),
        Word(e: "forty", t: "kırk, 40"),
        Word(e: "fifty", t: "elli, 50"),
        Word(e: "sixty", t: "altmış, 60"),
        Word(e: "seventy", t: "yetmiş, 70"),
        Word(e: "eighty", t: "seksen, 80"),
        Word(e: "ninety", t: "doksan, 90"),
        Word(e: "one hundred", t: "yüz, 100"),
        Word(e: "forty-five", t: "kırk beş, 45"),
        Word(e: "twenty-three", t: "yirmi üç, 23"),
        Word(e: "three hundred", t: "300"),
        Word(e: "time", t: "zaman, saat"),
        Word(e: "hour", t: "saat"),
        Word(e: "minute", t: "dakika"),
        Word(e: "second", t: "saniye"),
        Word(e: "appointment", t: "randevu"),
        Word(e: "date", t: "buluşma, tarih, randevu"),
        Word(e: "meeting", t: "toplantı"),
        Word(e: "past", t: "geçmiş, bitmiş, geçe"),
        Word(e: "when", t: "ne zaman, -dığında, -ken"),
        Word(e: "a.m.", t: "öğleden önce (gece 12'den öğlen 12'ye kadar)"),
        Word(e: "p.m.", t: "öğleden sonra (öğlen 12 ile gece 12 arası)"),
        Word(e: "see", t: "görmek, anlamak, görünmek"),
        Word(e: "take care", t: "kendine iyi bak"),
        Word(e: "mean", t: "demek istemek"),
        Word(e: "problem", t: "sorun"),
        Word(e: "no problem", t: "sorun yok"),
        Word(e: "worry", t: "endişelenmek"),
        Word(e: "mind", t: "dikkat etmek, mahsuru olmak, umursamak"),
        Word(e: "indeed", t: "hem de nasıl!"),
        Word(e: "congratulations", t: "tebrikler!"),
        Word(e: "bus", t: "otobüs"),
        Word(e: "train", t: "tren"),
        Word(e: "station", t: "istasyon"),
        Word(e: "train station", t: "gar, istasyon"),
        Word(e: "town", t: "kasaba"),
        Word(e: "city", t: "şehir"),
        Word(e: "capital", t: "başkent"),
        Word(e: "centre", t: "merkez"),
        Word(e: "city centre", t: "şehir merkezi"),
        Word(e: "park", t: "park"),
        Word(e: "pub", t: "bar"),
        Word(e: "theatre", t: "tiyatro"),
        Word(e: "library", t: "kütüphane"),
        Word(e: "foreigner", t: "yabancı"),
        Word(e: "map", t: "harita"),
        Word(e: "guide book", t: "şehir rehberi"),
        Word(e: "be going", t: "gitmek, gidiyor olmak"),
        Word(e: "find", t: "bulmak"),
        Word(e: "lost", t: "kayıp"),
        Word(e: "confused", t: "kafası karışmak"),
        Word(e: "over there", t: "orada"),
        Word(e: "cash", t: "nakit para"),
        Word(e: "card", t: "oyun kartı, kart"),
        Word(e: "credit card", t: "kredi kartı"),
        Word(e: "tips", t: "bahşiş"),
        Word(e: "red wine", t: "kırmızı şarap"),
        Word(e: "white wine", t: "beyaz şarap"),
        Word(e: "dinner", t: "akşam yemeği"),
        Word(e: "breakfast", t: "kahvaltı"),
        Word(e: "take", t: "getirmek, almak, kabul etmek"),
        Word(e: "more", t: "biraz daha, daha"),
        Word(e: "less", t: "daha az"),
        Word(e: "look", t: "bakmak, görünmek"),
        Word(e: "try", t: "denemek"),
        Word(e: "try on", t: "üstünde (bir şey) denemek"),
        Word(e: "expensive", t: "pahalı"),
        Word(e: "cheap", t: "ucuz"),
        Word(e: "really", t: "gerçekten"),
        Word(e: "this one", t: "bu"),
        Word(e: "that one", t: "şu"),
        Word(e: "question", t: "soru"),
        Word(e: "street", t: "sokak"),
        Word(e: "corner", t: "köşe"),
        Word(e: "building", t: "bina"),
        Word(e: "turn", t: "dönmek"),
        Word(e: "follow", t: "takip etmek"),
        Word(e: "stop", t: "durmak"),
        Word(e: "ask", t: "sormak"),
        Word(e: "left", t: "sol"),
        Word(e: "straight", t: "düz"),
        Word(e: "quick", t: "hızlı"),
        Word(e: "quickly", t: "hızlı (bir şekilde)"),
        Word(e: "slow", t: "yavaş"),
        Word(e: "slower", t: "daha yavaş"),
        Word(e: "on", t: "üstünde"),
        Word(e: "the United Kingdom", t: "Birleşik Krallık"),
        Word(e: "Germany", t: "Almanya"),
        Word(e: "Italy", t: "İtalya"),
        Word(e: "France", t: "Fransa"),
        Word(e: "Japan", t: "Japonya"),
        Word(e: "India", t: "Hindistan"),
        Word(e: "Egypt", t: "Mısır"),
        Word(e: "Canada", t: "Kanada"),
        Word(e: "Norway", t: "Norveç"),
        Word(e: "Sweden", t: "İsveç"),
        Word(e: "Korea", t: "Kore"),
        Word(e: "Scotland", t: "İskoçya"),
        Word(e: "journalist", t: "gazeteci"),
        Word(e: "doctor", t: "doktor"),
        Word(e: "dentist", t: "diş hekimi"),
        Word(e: "psychologist", t: "psikolog"),
        Word(e: "teacher", t: "öğretmen"),
        Word(e: "writer", t: "yazar"),
        Word(e: "professor", t: "profesör"),
        Word(e: "lawyer", t: "avukat"),
        Word(e: "artist", t: "sanatçı"),
        Word(e: "waiter", t: "garson (erkek)"),
        Word(e: "waitress", t: "garson (kadın)"),
        Word(e: "police officer", t: "polis memuru"),
        Word(e: "student", t: "öğrenci"),
        Word(e: "Mr", t: "Bay"),
        Word(e: "Mrs", t: "Bayan"),
        Word(e: "Miss", t: "Bayan (bekar)"),
        Word(e: "sweetheart", t: "tatlım"),
        Word(e: "darling", t: "hayatım"),
        Word(e: "tie", t: "kravat"),
        Word(e: "face", t: "yüz"),
        Word(e: "eye", t: "göz"),
        Word(e: "nose", t: "burun"),
        Word(e: "mouth", t: "ağız"),
        Word(e: "ear", t: "kulak"),
        Word(e: "tooth", t: "diş"),
        Word(e: "teeth", t: "dişler"),
        Word(e: "hair", t: "saç, kıl, tüy"),
        Word(e: "glasses", t: "gözlük"),
        Word(e: "story", t: "hikâye"),
        Word(e: "wear", t: "giymek"),
        Word(e: "write", t: "yazmak"),
        Word(e: "blonde", t: "sarışın"),
        Word(e: "ginger", t: "kızıl"),
        Word(e: "sometimes", t: "bazen"),
        Word(e: "every", t: "her"),
        Word(e: "body", t: "vücut"),
        Word(e: "arm", t: "kol"),
        Word(e: "leg", t: "bacak"),
        Word(e: "hand", t: "el"),
        Word(e: "foot", t: "ayak"),
        Word(e: "feet", t: "ayaklar"),
        Word(e: "toe", t: "ayak ucu, ayak parmağı"),
        Word(e: "finger", t: "parmak"),
        Word(e: "head", t: "baş"),
        Word(e: "neck", t: "boyun"),
        Word(e: "knee", t: "diz"),
        Word(e: "wrist", t: "bilek (el bileği)"),
        Word(e: "ankle", t: "bilek (ayak bileği)"),
        Word(e: "elbow", t: "dirsek"),
        Word(e: "shoulder", t: "omuz"),
        Word(e: "chest", t: "göğüs"),
        Word(e: "rib", t: "kaburga"),
        Word(e: "stomach", t: "karın"),
        Word(e: "heart", t: "kalp"),
        Word(e: "emergency", t: "acil bir durum"),
        Word(e: "accident", t: "kaza"),
        Word(e: "pain", t: "ağrı, acı"),
        Word(e: "stomachache", t: "karın ağrısı"),
        Word(e: "headache", t: "baş ağrısı"),
        Word(e: "injury", t: "yaralanma"),
        Word(e: "infection", t: "enfeksiyon"),
        Word(e: "cold", t: "nezle"),
        Word(e: "fever", t: "(yüksek) ateş"),
        Word(e: "medicine", t: "ilaç"),
        Word(e: "paper", t: "kağıt"),
        Word(e: "toilet", t: "tuvalet"),
        Word(e: "toilet paper", t: "tuvalet kâğıdı"),
        Word(e: "should", t: "-meli, -malı (tavsiye)"),
        Word(e: "feel", t: "hissetmek"),
        Word(e: "hurt", t: "acımak, acıtmak, incitmek"),
        Word(e: "vomit", t: "kusmak"),
        Word(e: "bleed", t: "kanamak"),
        Word(e: "lady", t: "hanımefendi"),
        Word(e: "gentleman", t: "beyefendi"),
        Word(e: "once", t: "bir kere"),
        Word(e: "ever after", t: "sonsuza dek"),
        Word(e: "million", t: "bir milyon"),
        Word(e: "way", t: "yol, bakım"),
        Word(e: "by the way", t: "bu arada"),
        Word(e: "in a way", t: "bir bakıma"),
        Word(e: "sort of", t: "sayılır, gibi"),
        Word(e: "come on", t: "hadi canım"),
        Word(e: "damn", t: "hay aksi"),
        Word(e: "look out", t: "dikkatli ol"),
        Word(e: "room", t: "oda"),
        Word(e: "kitchen", t: "mutfak"),
        Word(e: "bedroom", t: "yatak odası"),
        Word(e: "bathroom", t: "banyo"),
        Word(e: "living room", t: "oturma odası"),
        Word(e: "guest", t: "misafir"),
        Word(e: "guest room", t: "misafir odası"),
        Word(e: "upstairs", t: "üst kat"),
        Word(e: "downstairs", t: "alt kat"),
        Word(e: "next to", t: "yanında"),
        Word(e: "between", t: "arasında"),
        Word(e: "present", t: "hediye"),
        Word(e: "ring", t: "yüzük"),
        Word(e: "kiss", t: "öpücük"),
        Word(e: "hug", t: "sarılma"),
        Word(e: "watch", t: "kol saati"),
        Word(e: "mobile phone", t: "cep telefonu"),
        Word(e: "toy", t: "oyuncak"),
        Word(e: "flower", t: "çiçek"),
        Word(e: "new one", t: "yenisi"),
        Word(e: "give", t: "vermek"),
        Word(e: "him", t: "onu, ona (erkek)"),
        Word(e: "her", t: "onu, ona, onun (kadın)"),
        Word(e: "us", t: "bize, bizi"),
        Word(e: "them", t: "onları, onlara"),
        Word(e: "for him", t: "onun için (erkek)"),
        Word(e: "for them", t: "onlar için"),
        Word(e: "also", t: "de, da (hem de)"),
        Word(e: "already", t: "zaten, şimdiden"),
        Word(e: "but", t: "ama"),
        Word(e: "metre", t: "metre"),
        Word(e: "millimetre", t: "milimetre"),
        Word(e: "centimetre", t: "santimetre"),
        Word(e: "kilometre", t: "kilometre"),
        Word(e: "foot", t: "adım"),
        Word(e: "inch", t: "inç"),
        Word(e: "yard", t: "yard"),
        Word(e: "mile", t: "mil"),
        Word(e: "gram", t: "gram"),
        Word(e: "kilo", t: "kilo"),
        Word(e: "tonne", t: "ton"),
        Word(e: "point", t: "nokta"),
        Word(e: "weigh", t: "kilo olmak, ağırlığında olmak"),
        Word(e: "museum", t: "müze"),
        Word(e: "church", t: "kilise"),
        Word(e: "hotel", t: "otel"),
        Word(e: "gym", t: "spor salonu"),
        Word(e: "bridge", t: "köprü"),
        Word(e: "cinema", t: "sinema"),
        Word(e: "repeat", t: "tekrarlamak"),
        Word(e: "drive", t: "sürmek, arabayla gitmek"),
       Word(e: "close", t: "yakın"),
       Word(e: "near", t: "yakınında, yanında"),
       Word(e: "away", t: "uzak"),
       Word(e: "far away", t: "uzakta"),
       Word(e: "miles away", t: "kilometrelerce uzakta"),
       Word(e: "right here", t: "tam burada"),
       Word(e: "woman", t: "kadın"),
       Word(e: "man", t: "erkek"),
       Word(e: "boy", t: "erkek çocuk"),
       Word(e: "girl", t: "kız"),
       Word(e: "kindergarten", t: "anaokulu"),
       Word(e: "college", t: "lise"),
       Word(e: "university", t: "üniversite"),
       Word(e: "adult", t: "yetişkin"),
       Word(e: "baby", t: "bebek"),
       Word(e: "child", t: "çocuk"),
       Word(e: "children", t: "çocuklar"),
       Word(e: "study", t: "ders çalışmak, (okul) okumak"),
       Word(e: "his", t: "onun (erkek)"),
       Word(e: "our", t: "bizim"),
       Word(e: "their", t: "onların"),
       Word(e: "subject", t: "özne, konu, ders"),
       Word(e: "art", t: "sanat"),
       Word(e: "music", t: "müzik"),
       Word(e: "history", t: "tarih"),
       Word(e: "geography", t: "coğrafya"),
       Word(e: "maths", t: "matematik"),
       Word(e: "physics", t: "fizik"),
       Word(e: "chemistry", t: "kimya"),
       Word(e: "literature", t: "edebiyat"),
        Word(e: "sport", t: "spor"),
        Word(e: "language", t: "dil, lisan"),
        Word(e: "news", t: "haberler"),
        Word(e: "newspaper", t: "gazete"),
        Word(e: "magazine", t: "dergi"),
        Word(e: "film", t: "film"),
        Word(e: "TV", t: "televizyon"),
        Word(e: "show", t: "gösteri"),
        Word(e: "TV show", t: "televizyon programı"),
        Word(e: "watch", t: "izlemek"),
        Word(e: "read", t: "okumak"),
        Word(e: "love", t: "aşk, çok sevmek"),
        Word(e: "hate", t: "nefret etmek"),
        Word(e: "interested", t: "ilgili"),
        Word(e: "ambulance", t: "ambulans"),
        Word(e: "police", t: "polis"),
        Word(e: "call", t: "arama, yardım istemek, çağırmak"),
        Word(e: "broken", t: "kırık, bozuk"),
        Word(e: "bless you", t: "çok yaşa"),
        Word(e: "be careful", t: "dikkatli ol"),
        Word(e: "suck", t: "berbat olmak"),
        Word(e: "guess", t: "sanmak"),
        Word(e: "wait", t: "beklemek"),
        Word(e: "stuff", t: "şeyler"),
        Word(e: "never mind", t: "boşver"),
        Word(e: "whatever", t: "her neyse"),
        Word(e: "sweat", t: "terlemek"),
        Word(e: "holiday", t: "tatil"),
        Word(e: "country", t: "ülke"),
        Word(e: "flag", t: "bayrak"),
        Word(e: "place", t: "yer"),
        Word(e: "visa", t: "vize"),
        Word(e: "boarding pass", t: "biniş kartı"),
        Word(e: "passport", t: "pasaport"),
        Word(e: "ticket", t: "bilet"),
        Word(e: "airport", t: "havaalanı"),
        Word(e: "terminal", t: "terminal"),
        Word(e: "luggage", t: "bagaj"),
        Word(e: "suitcase", t: "bavul"),
        Word(e: "travel", t: "seyahat etmek"),
        Word(e: "visit", t: "ziyaret etmek"),
        Word(e: "show", t: "göstermek"),
        Word(e: "heavy", t: "ağır, şiddetli"),
        Word(e: "which", t: "hangi, -an, -en"),
        Word(e: "morning", t: "sabah"),
        Word(e: "afternoon", t: "öğleden sonra"),
        Word(e: "evening", t: "akşam"),
        Word(e: "night", t: "gece"),
        Word(e: "yesterday", t: "dün"),
        Word(e: "today", t: "bugün"),
        Word(e: "tomorrow", t: "yarın"),
        Word(e: "tonight", t: "bu gece"),
        Word(e: "late", t: "geç"),
        Word(e: "early", t: "erken"),
        Word(e: "dance", t: "dans etmek"),
        Word(e: "swim", t: "yüzmek"),
        Word(e: "walk", t: "yürümek, -e girmek"),
        Word(e: "run", t: "koşmak, yürütmek"),
        Word(e: "go out", t: "dışarı çıkmak"),
        Word(e: "sleep", t: "uyumak"),
        Word(e: "stay", t: "kalmak"),
        Word(e: "stay up", t: "uyanık kalmak"),
        Word(e: "first", t: "birinci, 1."),
        Word(e: "second", t: "ikinci, 2."),
        Word(e: "third", t: "üçüncü, 3."),
        Word(e: "fourth", t: "dördüncü, 4."),
        Word(e: "fifth", t: "beşinci, 5."),
        Word(e: "sixth", t: "altıncı, 6."),
        Word(e: "seventh", t: "yedinci, 7."),
        Word(e: "eighth", t: "sekizinci, 8."),
        Word(e: "ninth", t: "dokuzuncu, 9."),
        Word(e: "tenth", t: "onuncu, 10."),
        Word(e: "money", t: "para"),
        Word(e: "pound", t: "pound"),
        Word(e: "dollar", t: "dolar"),
        Word(e: "lira", t: "lira"),
        Word(e: "sale", t: "indirim"),
        Word(e: "on sale", t: "indirimde"),
        Word(e: "deal", t: "anlaşma"),
        Word(e: "offer", t: "teklif"),
        Word(e: "make", t: "yapmak, bulunmak"),
        Word(e: "spend", t: "harcamak"),
        Word(e: "lend", t: "ödünç vermek"),
        Word(e: "borrow", t: "ödünç almak"),
        Word(e: "owe", t: "borçlanmak, borçlu olmak"),
        Word(e: "pull", t: "çekiniz"),
        Word(e: "push", t: "itiniz"),
        Word(e: "furniture", t: "mobilya"),
        Word(e: "chair", t: "sandalye"),
        Word(e: "sofa", t: "koltuk"),
        Word(e: "cupboard", t: "dolap"),
        Word(e: "bookcase", t: "kitaplık"),
        Word(e: "bed", t: "yatak"),
        Word(e: "fridge", t: "buzdolabı"),
        Word(e: "freezer", t: "dondurucu"),
        Word(e: "stove", t: "ocak"),
        Word(e: "oven", t: "fırın"),
        Word(e: "chest of drawers", t: "çekmeceli dolap"),
        Word(e: "wardrobe", t: "elbise dolabı"),
        Word(e: "lamp", t: "lamba"),
        Word(e: "mirror", t: "ayna"),
        Word(e: "door", t: "kapı"),
        Word(e: "window", t: "pencere"),
        Word(e: "floor", t: "zemin"),
        Word(e: "ceiling", t: "tavan"),
        Word(e: "wall", t: "duvar"),
        Word(e: "roof", t: "çatı"),
        Word(e: "computer", t: "bilgisayar"),
        Word(e: "laptop", t: "dizüstü bilgisayar"),
        Word(e: "charger", t: "şarj aleti"),
        Word(e: "camera", t: "fotoğraf makinesi"),
        Word(e: "pen", t: "tükenmez kalem"),
        Word(e: "pencil", t: "kurşun kalem"),
        Word(e: "key", t: "anahtar"),
        Word(e: "lock", t: "kilit"),
        Word(e: "how many", t: "kaç (sayılabilir isimlerden önce)"),
        Word(e: "how much", t: "ne kadar (sayılamayan isimlerden önce)"),
        Word(e: "under", t: "altında"),
        Word(e: "behind", t: "arkasında"),
        Word(e: "in front of", t: "önünde"),
        Word(e: "flight", t: "uçuş"),
        Word(e: "ship", t: "gemi"),
        Word(e: "plane", t: "uçak"),
        Word(e: "helicopter", t: "helikopter"),
        Word(e: "mountain", t: "dağ"),
        Word(e: "sea", t: "deniz"),
        Word(e: "beach", t: "sahil"),
        Word(e: "lake", t: "göl"),
        Word(e: "fly", t: "uçmak"),
        Word(e: "sail", t: "yelken açmak"),
        Word(e: "delayed", t: "gecikmeli"),
        Word(e: "on time", t: "zamanında, vakitli"),
        Word(e: "plan", t: "plan"),
        Word(e: "popcorn", t: "patlamış mısır"),
        Word(e: "come", t: "gelmek"),
        Word(e: "later", t: "sonrası, sonra"),
        Word(e: "figure", t: "hesaplamak"),
        Word(e: "figure out", t: "çözmek"),
        Word(e: "thrilled", t: "çok heyecanlanmak"),
        Word(e: "moon", t: "ay (dünyanın uydusu)"),
        Word(e: "serious", t: "ciddi"),
        Word(e: "seriously", t: "cidden mi?"),
        Word(e: "oh dear", t: "aman allahım"),
        Word(e: "hold on", t: "hatta kalın"),
        Word(e: "hang on", t: "bekleyin"),
        Word(e: "unbelievable", t: "inanılmaz"),
        Word(e: "will", t: "-ecek, -acak"),
        Word(e: "play", t: "oynamak"),
        Word(e: "game", t: "oyun, maç"),
        Word(e: "maybe", t: "belki"),
        Word(e: "instead", t: "bunun yerine"),
        Word(e: "other", t: "diğer, diğeri"),
        Word(e: "the others", t: "diğerleri"),
        Word(e: "all of us", t: "hepimiz"),
        Word(e: "both", t: "her ikisi de"),
        Word(e: "both of us", t: "ikimiz de"),
        Word(e: "world", t: "dünya"),
        Word(e: "play", t: "oyun"),
        Word(e: "garden", t: "bahçe"),
        Word(e: "party", t: "parti"),
        Word(e: "club", t: "gece kulübü"),
        Word(e: "get up", t: "(yataktan) kalkmak"),
        Word(e: "hang out", t: "birileriyle takılmak"),
        Word(e: "everyone", t: "herkes"),
        Word(e: "no one", t: "hiç kimse"),
        Word(e: "someone", t: "birisi, biri"),
        Word(e: "anyone", t: "herhangi biri, hiç kimse"),
        Word(e: "with me", t: "benimle"),
        Word(e: "with you", t: "seninle"),
        Word(e: "winter", t: "kış"),
        Word(e: "summer", t: "yaz"),
        Word(e: "spring", t: "ilkbahar"),
        Word(e: "autumn", t: "sonbahar"),
        Word(e: "work", t: "iş"),
        Word(e: "next", t: "gelecek, sonraki, ileri"),
        Word(e: "back", t: "arka, geri"),
        Word(e: "soon", t: "birazdan, yakında"),
        Word(e: "before", t: "önünde, -den önce, önceki"),
        Word(e: "after", t: "sonra, -den sonra"),
        Word(e: "letter", t: "mektup, harf"),
        Word(e: "parcel", t: "paket"),
        Word(e: "essay", t: "deneme"),
        Word(e: "dishes", t: "bulaşıklar"),
        Word(e: "laundry", t: "kirli çamaşırlar"),
        Word(e: "clean", t: "temiz"),
        Word(e: "dirty", t: "kirli"),
        Word(e: "clean", t: "temizlemek"),
        Word(e: "help", t: "yardım etmek"),
        Word(e: "send", t: "göndermek"),
        Word(e: "receive", t: "almak"),
        Word(e: "return", t: "geri vermek, geri dönmek"),
        Word(e: "alone", t: "yalnız"),
        Word(e: "journey", t: "yolculuk"),
        Word(e: "trip", t: "gezi"),
        Word(e: "gap", t: "boşluk"),
        Word(e: "gap", t: "boşluk"),
        Word(e: "leave", t: "ayrılmak, bırakmak"),
        Word(e: "arrive", t: "varmak"),
        Word(e: "safe", t: "güvenli"),
        Word(e: "unattended", t: "gözetimsiz"),
        Word(e: "Monday", t: "Pazartesi"),
        Word(e: "Tuesday", t: "Salı"),
        Word(e: "Wednesday", t: "Çarşamba"),
        Word(e: "Thursday", t: "Perşembe"),
        Word(e: "Friday", t: "Cuma"),
        Word(e: "Saturday", t: "Cumartesi"),
        Word(e: "Sunday", t: "Pazar"),
        Word(e: "birthday", t: "doğum günü"),
        Word(e: "exciting", t: "heyecanlı, heyecan verici"),
        Word(e: "fun", t: "eğlenceli"),
        Word(e: "funny", t: "matrak, komik"),
        Word(e: "boring", t: "sıkıcı"),
        Word(e: "relax", t: "dinlenmek"),
        Word(e: "one thousand", t: "1.000"),
        Word(e: "two thousand", t: "2.000"),
        Word(e: "two thousand and one", t: "2001 (yıl), 2,001"),
        Word(e: "two thousand and seventeen", t: "2017 (yıl), 2,017"),
        Word(e: "nineteen ninety-nine", t: "1999"),
        Word(e: "quarter", t: "çeyrek"),
        Word(e: "how long", t: "ne kadar süre"),
        Word(e: "life", t: "hayat, yaşam"),
        Word(e: "death", t: "ölüm"),
        Word(e: "education", t: "eğitim"),
        Word(e: "shower", t: "duş, sağanak yağış"),
        Word(e: "hope", t: "ummak"),
        Word(e: "then", t: "sonra, öyleyse"),
        Word(e: "last", t: "son, geçen"),
        Word(e: "ago", t: "önce"),
        Word(e: "last time", t: "geçen sefer"),
        Word(e: "conversation", t: "sohbet"),
        Word(e: "topic", t: "konu"),
        Word(e: "relationship", t: "ilişki, alaka"),
        Word(e: "weather", t: "hava"),
        Word(e: "politics", t: "siyaset"),
        Word(e: "technology", t: "teknoloji"),
        Word(e: "health", t: "sağlık"),
        Word(e: "science", t: "bilim"),
        Word(e: "tell", t: "anlatmak"),
        Word(e: "about", t: "hakkında"),
        Word(e: "talk", t: "konuşmak, anlatmak"),
        Word(e: "crime", t: "suç"),
        Word(e: "punishment", t: "ceza"),
        Word(e: "culture", t: "kültür"),
        Word(e: "argument", t: "argüman, tartışma"),
        Word(e: "important", t: "önemli"),
        Word(e: "interesting", t: "ilginç"),
        Word(e: "curious", t: "meraklı"),
        Word(e: "embarrassed", t: "mahçup olmak, utanmak"),
        Word(e: "football", t: "futbol"),
        Word(e: "badminton", t: "badminton"),
        Word(e: "basketball", t: "basketbol"),
        Word(e: "baseball", t: "beyzbol"),
        Word(e: "ice hockey", t: "buz hokeyi"),
        Word(e: "golf", t: "golf"),
        Word(e: "gymnastics", t: "cimnastik"),
        Word(e: "boxing", t: "boks"),
        Word(e: "tennis", t: "tenis"),
        Word(e: "cricket", t: "kriket"),
        Word(e: "sailing", t: "yelken sporu"),
        Word(e: "fish", t: "balık tutmak"),
        Word(e: "fishing", t: "balıkçılık, balık tutma"),
        Word(e: "point", t: "anlam, sayı"),
        Word(e: "sense", t: "anlam"),
        Word(e: "mind", t: "akıl"),
        Word(e: "win", t: "kazanmak, birinci olmak"),
        Word(e: "lose", t: "zarar etmek, kaybetmek"),
        Word(e: "such", t: "öyle, böyle, bu kadar, o kadar"),
        Word(e: "fool", t: "aptal, saf"),
        Word(e: "calm", t: "sakin"),
        Word(e: "calm down", t: "sakin ol"),
        Word(e: "be quiet", t: "sessiz ol"),
        Word(e: "north", t: "kuzey"),
        Word(e: "south", t: "güney"),
        Word(e: "east", t: "doğu"),
        Word(e: "west", t: "batı"),
        Word(e: "America", t: "Amerika"),
        Word(e: "Europe", t: "Avrupa"),
        Word(e: "Africa", t: "Afrika"),
        Word(e: "Asia", t: "Asya"),
        Word(e: "Australia", t: "Avustralya"),
        Word(e: "Antarctica", t: "Antarktika"),
        Word(e: "thriller", t: "gerilim"),
        Word(e: "comedy", t: "komedi"),
        Word(e: "documentary", t: "belgesel"),
        Word(e: "fiction", t: "kurgu"),
       Word(e: "drama", t: "dram"),
       Word(e: "gardening", t: "bahçecilik"),
       Word(e: "kind of", t: "bir tür, az çok"),
       Word(e: "sing", t: "şarkı söylemek"),
       Word(e: "enjoy", t: "sevmek"),
       Word(e: "prefer", t: "tercih etmek"),
       Word(e: "Japanese", t: "Japonca, Japon"),
       Word(e: "Indian", t: "Hintli"),
       Word(e: "Asian", t: "Asyalı"),
       Word(e: "European", t: "Avrupalı"),
       Word(e: "career", t: "kariyer"),
       Word(e: "move", t: "taşımak, taşınmak"),
       Word(e: "retire", t: "emekli olmak"),
       Word(e: "quit", t: "bırakmak"),
       Word(e: "come back", t: "geri gelmek"),
       Word(e: "go skiing", t: "kayağa gitmek"),
       Word(e: "abroad", t: "yurtdışı"),
       Word(e: "go abroad", t: "yurtdışına çıkmak"),
       Word(e: "pretty", t: "oldukça, güzel"),
       Word(e: "still", t: "hâlâ"),
       Word(e: "together", t: "birlikte"),
       Word(e: "usually", t: "genellikle"),
       Word(e: "experience", t: "tecrübe"),
       Word(e: "festival", t: "festival"),
       Word(e: "bus trip", t: "otobüs gezisi"),
       Word(e: "hostel", t: "pansiyon"),
       Word(e: "tour guide", t: "tur rehberi"),
       Word(e: "parachuting", t: "paraşütle atlama"),
        Word(e: "river rafting", t: "rafting"),
        Word(e: "hike", t: "arazi yürüyüşü yapmak"),
        Word(e: "diverse", t: "çeşitli, farklı"),
        Word(e: "remarkable", t: "dikkat çekici"),
        Word(e: "famous", t: "ünlü"),
        Word(e: "scary", t: "korkunç"),
        Word(e: "strange", t: "garip"),
        Word(e: "strangest", t: "en garip"),
        Word(e: "scariest", t: "en korkunç"),
        Word(e: "worse", t: "daha kötü"),
        Word(e: "worst", t: "en kötü"),
        Word(e: "better", t: "daha iyi"),
        Word(e: "best", t: "en iyi"),
        Word(e: "definitely", t: "kesinlikle"),
        Word(e: "president", t: "başkan"),
        Word(e: "minister", t: "bakan"),
        Word(e: "prime minister", t: "başbakan"),
        Word(e: "king", t: "kral"),
        Word(e: "queen", t: "kraliçe"),
        Word(e: "politician", t: "siyasetçi"),
        Word(e: "government", t: "hükümet"),
        Word(e: "leader", t: "lider"),
        Word(e: "power", t: "güç, yetki"),
        Word(e: "congress", t: "kongre"),
        Word(e: "senate", t: "senato"),
        Word(e: "parliament", t: "meclis"),
        Word(e: "labour", t: "işçi"),
        Word(e: "excellent", t: "mükemmel"),
        Word(e: "shot", t: "atış, deneme, şans"),
        Word(e: "certain", t: "kesin"),
        Word(e: "final", t: "son"),
        Word(e: "step", t: "adım"),
        Word(e: "simple", t: "basit"),
        Word(e: "hard", t: "zor"),
        Word(e: "opinion", t: "fikir"),
        Word(e: "none", t: "hiç"),
        Word(e: "concern", t: "alaka, ilgi, kaygı"),
        Word(e: "joke", t: "fıkra"),
        Word(e: "bike", t: "bisiklet"),
        Word(e: "be good at", t: "-de iyi olmak"),
        Word(e: "be bad at", t: "-de kötü olmak"),
        Word(e: "instrument", t: "araç, enstrüman"),
        Word(e: "guitar", t: "gitar"),
        Word(e: "piano", t: "piyano"),
        Word(e: "cook", t: "pişirmek, yemek yapmak"),
        Word(e: "paint", t: "boyamak, yağlı boya resim yapmak"),
        Word(e: "listen", t: "dinlemek"),
        Word(e: "easy", t: "kolay"),
        Word(e: "difficult", t: "zor"),
        Word(e: "foreign", t: "yabancı"),
        Word(e: "dangerous", t: "tehlikeli"),
        Word(e: "especially", t: "özellikle"),
        Word(e: "example", t: "örnek"),
        Word(e: "for example", t: "mesela"),
        Word(e: "photo", t: "fotoğraf"),
        Word(e: "picture", t: "resim"),
        Word(e: "video", t: "video"),
        Word(e: "souvenir", t: "hediyelik eşya"),
        Word(e: "village", t: "köy"),
        Word(e: "island", t: "ada"),
        Word(e: "view", t: "manzara"),
        Word(e: "buffet", t: "büfe"),
        Word(e: "surprise", t: "sürpriz"),
        Word(e: "staff", t: "personel"),
        Word(e: "hear", t: "duymak, dinlemek, haber almak"),
        Word(e: "smell", t: "koklamak, kokmak"),
        Word(e: "taste", t: "tatmak, tat almak, tadında olmak"),
        Word(e: "remote", t: "uzak, ücra"),
        Word(e: "incredible", t: "inanılmaz"),
        Word(e: "fantastic", t: "harika, şahane"),
        Word(e: "awful", t: "berbat"),
        Word(e: "disappointing", t: "moral bozucu"),
        Word(e: "again", t: "tekrar"),
        Word(e: "these", t: "bunlar"),
        Word(e: "those", t: "şunlar"),
        Word(e: "military", t: "askeriye"),
        Word(e: "soldier", t: "asker"),
        Word(e: "general", t: "komutan, general"),
        Word(e: "war", t: "savaş"),
        Word(e: "peace", t: "barış"),
        Word(e: "law", t: "kanun"),
        Word(e: "special", t: "özel"),
        Word(e: "state", t: "devlet"),
        Word(e: "economy", t: "ekonomi"),
        Word(e: "taxes", t: "vergiler"),
        Word(e: "promise", t: "söz, söz vermek")
            
    ]
    
    let pageStatistic = ["\(UserDefaults.standard.integer(forKey: "blueExerciseCount")) defa alıştırma yaptınız", "\(UserDefaults.standard.integer(forKey: "blueAllTrue")) alıştırmayı hepsini doğru yaparak tamamladınız" ,"\(UserDefaults.standard.integer(forKey: "blueTrueCount")) defa doğru cevap verdiniz", "\(UserDefaults.standard.integer(forKey: "blueFalseCount")) defa yanlış cevap verdiniz"]
    
    mutating func findFiveWords(){
        
       
        
    }
    
    mutating func getQuestionText(_ selectedSegmentIndex: Int, _ whichQuestion: Int, _ startPressed:Int) -> String {
        
        questionNumbers.removeAll()
        
        loadItems()
        loadItemsQuiz()
        loadItemsMyQuiz()
        loadsQuizCoreDataArray()

        // these will be return a function
                if UserDefaults.standard.string(forKey: "whichButton") == "green" {

                    let fiveIndex =  UserDefaults.standard.array(forKey: "fiveIndex") as? [Int] ?? [Int]()
                    
                    switch whichQuestion {
                            case 0, 5, 10, 15,23,26:
                                questionNumber = fiveIndex[0]
                                break
                            case 1, 6, 11, 16,24,30:
                                questionNumber = fiveIndex[1]
                                break
                            case 2, 7, 12, 17,20,29:
                                questionNumber = fiveIndex[2]
                                break
                            case 3, 8, 13, 18,22,25:
                                questionNumber = fiveIndex[3]
                                break
                            case 4, 9, 14, 19,21,28:
                                questionNumber = fiveIndex[4]
                                break
                            default:
                                print("errror")
                    }
                    
                    
                    for i in 0..<quiz.count {
                        questionNumbers.append(i)
                    }
                } else {
                    print("<*>\(HardItemArray)")
                    questionNumber = Int.random(in: 0..<HardItemArray.count)
                    for i in 0..<HardItemArray.count {
                        questionNumbers.append(i)
                    }
                 
                }
        
        //need for result view
            rightOnce.append(questionNumber)
            UserDefaults.standard.set(rightOnce, forKey: "rightOnce")
                
        changedQuestionNumber = questionNumber + Int.random(in: 0...9)
        self.selectedSegmentIndex = selectedSegmentIndex
     
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
  
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            if startPressed == 1 {
                return selectedSegmentIndex == 0 ? quiz[questionNumber].eng : quiz[questionNumber].tr
                
            } else {
                return startPressed == 2 ? quiz[questionNumber].tr : quiz[questionNumber].eng
            }
        } else {
            if startPressed == 1 {
                return selectedSegmentIndex == 0 ? HardItemArray[questionNumber].eng! : HardItemArray[questionNumber].tr!
                
            } else {
                return  startPressed == 2 ? HardItemArray[questionNumber].tr! : HardItemArray[questionNumber].eng!
            }
            
        }
      
    } //getQuestionText
    
    func getAnswer() -> String{
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            return quiz[questionNumber].eng
        } else {
            return HardItemArray[questionNumber].eng!
        }
    }
    
    func getAnswerTR() -> String{
        return quiz[questionNumber].tr
    }
    
    func getQuestionNumber() -> Int {
        return questionNumber
    }

    func getOriginalList() -> String {
        return HardItemArray[questionNumber].originalList!
    }
    
    func getQuestionTextForSegment() -> String
    {
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            return quiz[questionNumber].eng
        } else {
            return HardItemArray[questionNumber].eng!
        }
    }
    
    mutating func nextQuestion() {
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            if questionNumber + 1 < quiz.count {
                questionNumber += 1
            } else {
                questionNumber = 0
            }
        } else {
            if questionNumber + 1 < HardItemArray.count {
                questionNumber += 1
            } else {
                questionNumber = 0
            }
        }
       
   }
    
    //MARK: - checkAnswer
    mutating func checkAnswer(userAnswer: String) -> Bool {
        var trueAnswer = ""
        print("####HardItemArray>>\(HardItemArray)")
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
             trueAnswer = selectedSegmentIndex == 0 ? quiz[questionNumber].tr : quiz[questionNumber].eng
        } else {
             trueAnswer = selectedSegmentIndex == 0 ? HardItemArray[questionNumber].tr! : HardItemArray[questionNumber].eng!
            
            arrayForResultViewENG.append(HardItemArray[questionNumber].eng ?? "empty")
            UserDefaults.standard.set(arrayForResultViewENG, forKey: "arrayForResultViewENG")
            
            arrayForResultViewTR.append(HardItemArray[questionNumber].tr ?? "empty")
            UserDefaults.standard.set(arrayForResultViewTR, forKey: "arrayForResultViewTR")
           
        }
        
        if userAnswer == trueAnswer {
            //need for result view
            rightOnceBool.append(true)
            UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return true
        } else {
            //need for result view
            rightOnceBool.append(false)
            UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    mutating func arrayForResultView(){
        arrayForResultViewENG.append(HardItemArray[questionNumber].eng ?? "empty")
        UserDefaults.standard.set(arrayForResultViewENG, forKey: "arrayForResultViewENG")
        
        arrayForResultViewTR.append(HardItemArray[questionNumber].tr ?? "empty")
        UserDefaults.standard.set(arrayForResultViewTR, forKey: "arrayForResultViewTR")
    }
    
    mutating func answerTrue(){ // except test option
        rightOnceBool.append(true)
        UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
        UserDefaults.standard.synchronize()
    }
    
    mutating func answerFalse() { // // except test option
        rightOnceBool.append(false)
        UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
        UserDefaults.standard.synchronize()
    }
    
    mutating func userGotItRight() -> Bool {
                
        
        var i = HardItemArray[questionNumber].correctNumber
        i = i - 1
        HardItemArray[questionNumber].correctNumber = i
        
        let originalindex = HardItemArray[questionNumber].originalindex


        if let itemm = itemArray.first(where: {$0.uuid == HardItemArray[questionNumber].uuid}) {
            itemm.trueCount += 1
        } else {
           // item could not be found
        }
            
        if HardItemArray[questionNumber].correctNumber <= 0 {
            
            // the word DELETE from hard words
            if HardItemArray[questionNumber].originalList == "Words" {
                print("delete quiz item")
                quizCoreDataArray[Int(originalindex)].add = false
            } else {
                
                if itemArray.count > Int(originalindex) {

                    if let itemm = itemArray.first(where: {$0.uuid == HardItemArray[questionNumber].uuid}) {
                        itemm.add = false
                    } else {
                       // item could not be found
                    }
                }
            }
            
            context.delete(HardItemArray[questionNumber])
            HardItemArray.remove(at: questionNumber)
            
            
            let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
            UserDefaults.standard.set(lastCount-1, forKey: "hardWordsCount")
    
        }
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        return HardItemArray.count < 2 ? true : false
    }
    
    func updateFalseCountHardWords(){

        if let itemm = itemArray.first(where: {$0.uuid == HardItemArray[questionNumber].uuid}) {
            itemm.falseCount += 1
        } else {
           // item could not be found
        }
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func updateTrueCountWords(){
        
        quizCoreDataArray[questionNumber].trueCount += 1
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    mutating func userGotItWrong() {
        
        quizCoreDataArray[questionNumber].falseCount += 1
        print("BlueFalse-\( quizCoreDataArray[questionNumber].falseCount)")

        // if word didn't added to hard words
        if quizCoreDataArray[questionNumber].add == false{
            let newItem = HardItem(context: context)
            newItem.eng = quiz[questionNumber].eng
            newItem.tr = quiz[questionNumber].tr
            newItem.originalindex = Int32(questionNumber)
            newItem.originalList = "Words"
            newItem.date = Date()
            newItem.correctNumber = 5
            HardItemArray.append(newItem)
            
            isWordAddedToHardWords = isWordAddedToHardWords + 1
            
            // the word ADD to hard words
            quizCoreDataArray[questionNumber].add = true
            let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
            UserDefaults.standard.set(lastCount+1, forKey: "hardWordsCount")
   
        }
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
    }
    
    mutating func addHardWords(_ number: Int) {
 
        loadItems()
        
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            loadItemsQuiz()
            // if word didn't added to hard words
            if quizCoreDataArray[number].add == false{
                let newItem = HardItem(context: context)
                newItem.eng = quiz[number].eng
                newItem.tr = quiz[number].tr
                newItem.originalindex = Int32(number)
                newItem.originalList = "Words"
                newItem.date = Date()
                newItem.correctNumber = 5
                HardItemArray.append(newItem)
                // the word ADD to hard words
                quizCoreDataArray[number].add = true
                let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
                UserDefaults.standard.set(lastCount+1, forKey: "hardWordsCount")
       
            }
        } else {
            loadItemsMyQuiz()
            
            if itemArray[number].add == false{
                let newItem = HardItem(context: context)
                newItem.eng = itemArray[number].eng
                newItem.tr = itemArray[number].tr
                newItem.uuid = itemArray[number].uuid
                newItem.originalindex = Int32(number)
                newItem.originalList = "MyWords"
                newItem.date = Date()
                newItem.correctNumber = 5
                HardItemArray.append(newItem)
                // the word ADD to hard words
                itemArray[questionNumber].add = true
                let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
                UserDefaults.standard.set(lastCount+1, forKey: "hardWordsCount")

            }
        }

        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
    }
    
    mutating func getIsWordAddedToHardWords() -> Int {
        return isWordAddedToHardWords
    }
    
    mutating func getProgress() -> Float {
        onlyHereNumber += 1
        var totalQuestionNumber = 25.0
        _ = totalQuestionNumber //no need
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            totalQuestionNumber = 30.0
        }
        
        return Float(onlyHereNumber) / Float(totalQuestionNumber)
    }
    

    //MARK: - getAnswer
    mutating func getAnswer(_ sender: Int) -> String {
        if changedQuestionNumber % 2 == sender {
            
            if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                return selectedSegmentIndex == 0 ? quiz[questionNumber].tr : quiz[questionNumber].eng
            } else {
                return selectedSegmentIndex == 0 ? HardItemArray[questionNumber].tr! : HardItemArray[questionNumber].eng!
            }
            
        } else {
            answer = Int.random(in: 0..<questionNumbersCopy.count)
            let temp = questionNumbersCopy[answer]
                        
            if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                return selectedSegmentIndex == 0 ? quiz[temp].tr : quiz[temp].eng
            } else {
                return selectedSegmentIndex == 0 ? HardItemArray[temp].tr! : HardItemArray[temp].eng!
            }
            
        }
    }
    
    mutating func loadItems(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            HardItemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadItemsQuiz(with request: NSFetchRequest<AddedList> = AddedList.fetchRequest()){
        do {
            quizCoreDataArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadItemsMyQuiz(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadsQuizCoreDataArray(with request: NSFetchRequest<AddedList> = AddedList.fetchRequest()){
        do {
           // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
            quizCoreDataArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func calculateLevel() -> Float {
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        switch lastPoint {
        case Int(INT16_MIN)..<0:
            UserDefaults.standard.set(0, forKey: "level")
            UserDefaults.standard.set(0-lastPoint, forKey: "needPoint")
            return 0.0
        case 0..<500: //500
            UserDefaults.standard.set(1, forKey: "level")
            UserDefaults.standard.set(500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-0))/Float(500-0)
        case 500..<1100: //600
            UserDefaults.standard.set(2, forKey: "level")
            UserDefaults.standard.set(1100-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-500))/Float(1100-500)
            
        case 1100..<1800: //700
            UserDefaults.standard.set(3, forKey: "level")
            UserDefaults.standard.set(1800-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1100))/Float(1800-1100)
            
        case 1800..<2600: //800
            UserDefaults.standard.set(4, forKey: "level")
            UserDefaults.standard.set(2600-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1800))/Float(2600-1800)
            
        case 2600..<3500: //900
            UserDefaults.standard.set(5, forKey: "level")
            UserDefaults.standard.set(3500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2600))/Float(3500-2600)
            
        case 3500..<4500: //1000
            UserDefaults.standard.set(6, forKey: "level")
            UserDefaults.standard.set(4500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3500))/Float(4500-3500)
            
        case 4500..<5700: //1200
            UserDefaults.standard.set(7, forKey: "level")
            UserDefaults.standard.set(5700-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4500))/Float(5700-4500)
            
        case 5700..<7100: //1400
            UserDefaults.standard.set(8, forKey: "level")
            UserDefaults.standard.set(7100-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5700))/Float(7100-5700)
            
        case 7100..<8700: //1600
            UserDefaults.standard.set(9, forKey: "level")
            UserDefaults.standard.set(8700-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7100))/Float(8700-7100)
            
        case 8700..<10500: //1800
            UserDefaults.standard.set(10, forKey: "level")
            UserDefaults.standard.set(10500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8700))/Float(10500-8700)
            
        case 10500..<12500: //2000
            UserDefaults.standard.set(11, forKey: "level")
            UserDefaults.standard.set(12500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-10500))/Float(12500-10500)
            
        case 12500..<15000: //2500
            UserDefaults.standard.set(12, forKey: "level")
            UserDefaults.standard.set(15000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-12500))/Float(15000-12500)
            
        case 15000..<18000: //3000
            UserDefaults.standard.set(13, forKey: "level")
            UserDefaults.standard.set(18000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-15000))/Float(18000-15000)
            
        case 18000..<21500: //3500
            UserDefaults.standard.set(14, forKey: "level")
            UserDefaults.standard.set(21500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-18000))/Float(21500-18000)
            
        case 21500..<26000: //4500
            UserDefaults.standard.set(15, forKey: "level")
            UserDefaults.standard.set(26000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-21500))/Float(26000-21500)
            
        case 26000..<32000: //6000
            UserDefaults.standard.set(16, forKey: "level")
            UserDefaults.standard.set(32000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-26000))/Float(32000-26000)
            
        case 32000..<40000: //8000
            UserDefaults.standard.set(17, forKey: "level")
            UserDefaults.standard.set(40000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-32000))/Float(40000-32000)
            
        case 40000..<50000: //10000
            UserDefaults.standard.set(18, forKey: "level")
            UserDefaults.standard.set(50000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-40000))/Float(50000-40000)
            
        case 50000..<62000: //12000
            UserDefaults.standard.set(19, forKey: "level")
            UserDefaults.standard.set(62000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-50000))/Float(62000-50000)
            
        case 62000..<77000: //15000
            UserDefaults.standard.set(20, forKey: "level")
            UserDefaults.standard.set(77000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-62000))/Float(77000-62000)
            
        case 77000..<97000: //20000
            UserDefaults.standard.set(21, forKey: "level")
            UserDefaults.standard.set(97000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-77000))/Float(97000-77000)
            
        case 97000..<120000: //23000
            UserDefaults.standard.set(22, forKey: "level")
            UserDefaults.standard.set(120000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-97000))/Float(120000-97000)
            
        case 120000..<145000: //25000
            UserDefaults.standard.set(23, forKey: "level")
            UserDefaults.standard.set(145000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-120000))/Float(145000-120000)
            
        case 145000..<175000: //30000
            UserDefaults.standard.set(24, forKey: "level")
            UserDefaults.standard.set(175000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-145000))/Float(175000-145000)
            
        case 175000..<210000: //35000
            UserDefaults.standard.set(25, forKey: "level")
            UserDefaults.standard.set(210000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-175000))/Float(210000-175000)
            
        case 210000..<250000: //40000
            UserDefaults.standard.set(26, forKey: "level")
            UserDefaults.standard.set(250000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-210000))/Float(250000-210000)
            
        case 250000..<300000: //50000
            UserDefaults.standard.set(27, forKey: "level")
            UserDefaults.standard.set(300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-250000))/Float(300000-250000)
            
        case 300000..<350000: //50000
            UserDefaults.standard.set(28, forKey: "level")
            UserDefaults.standard.set(350000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-300000))/Float(350000-300000)
            
        case 350000..<400000: //50000
            UserDefaults.standard.set(29, forKey: "level")
            UserDefaults.standard.set(400000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-350000))/Float(400000-350000)
            
        case 400000..<500000: //100000
            UserDefaults.standard.set(30, forKey: "level")
            UserDefaults.standard.set(500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-400000))/Float(500000-400000)
            
        case 500000..<600000: //100000
            UserDefaults.standard.set(31, forKey: "level")
            UserDefaults.standard.set(600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-500000))/Float(600000-500000)
            
        case 600000..<700000: //100000
            UserDefaults.standard.set(32, forKey: "level")
            UserDefaults.standard.set(700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-600000))/Float(700000-600000)
            
        case 700000..<800000: //100000
            UserDefaults.standard.set(33, forKey: "level")
            UserDefaults.standard.set(800000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-700000))/Float(800000-700000)
            
        case 800000..<900000: //100000
            UserDefaults.standard.set(34, forKey: "level")
            UserDefaults.standard.set(900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-800000))/Float(900000-800000)
            
        case 900000..<1000000: //100000
            UserDefaults.standard.set(35, forKey: "level")
            UserDefaults.standard.set(1000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-900000))/Float(1000000-900000)
            
        case 1000000..<1200000: //200000
            UserDefaults.standard.set(36, forKey: "level")
            UserDefaults.standard.set(1200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1000000))/Float(1200000-1000000)
            
        case 1200000..<1400000: //200000
            UserDefaults.standard.set(37, forKey: "level")
            UserDefaults.standard.set(1400000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1200000))/Float(1400000-1200000)
            
        case 1400000..<1600000: //200000
            UserDefaults.standard.set(38, forKey: "level")
            UserDefaults.standard.set(1600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1400000))/Float(1600000-1400000)

            
        case 1600000..<2000000: //200000
            UserDefaults.standard.set(39, forKey: "level")
            UserDefaults.standard.set(2000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1600000))/Float(2000000-1600000)
            
        case 2000000..<2300000: //300000 //2million
            UserDefaults.standard.set(40, forKey: "level")
            UserDefaults.standard.set(2300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2000000))/Float(2300000-2000000)
            
        case 2300000..<2600000: //300000
            UserDefaults.standard.set(41, forKey: "level")
            UserDefaults.standard.set(2600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2300000))/Float(2600000-2300000)
            
        case 2600000..<2900000: //300000
            UserDefaults.standard.set(42, forKey: "level")
            UserDefaults.standard.set(2900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2600000))/Float(2900000-2600000)
            
        case 2900000..<3200000: //300000
            UserDefaults.standard.set(43, forKey: "level")
            UserDefaults.standard.set(3200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2900000))/Float(3200000-2900000)
            
        case 3200000..<3500000: //300000
            UserDefaults.standard.set(44, forKey: "level")
            UserDefaults.standard.set(3500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3200000))/Float(3500000-3200000)
            
        case 3500000..<3800000: //300000
            UserDefaults.standard.set(45, forKey: "level")
            UserDefaults.standard.set(3800000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3500000))/Float(3800000-3500000)
            
        case 3800000..<4100000: //300000
            UserDefaults.standard.set(46, forKey: "level")
            UserDefaults.standard.set(4100000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3800000))/Float(4100000-3800000)
            
        case 4100000..<4500000: //400000
            UserDefaults.standard.set(47, forKey: "level")
            UserDefaults.standard.set(4500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4100000))/Float(4500000-4100000)
            
        case 4500000..<4900000: //400000
            UserDefaults.standard.set(48, forKey: "level")
            UserDefaults.standard.set(4900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4500000))/Float(4900000-4500000)
            
        case 4900000..<5300000: //400000
            UserDefaults.standard.set(49, forKey: "level")
            UserDefaults.standard.set(5300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4900000))/Float(5300000-4900000)
            
        case 5300000..<5700000: //400000
            UserDefaults.standard.set(50, forKey: "level")
            UserDefaults.standard.set(5700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5300000))/Float(5700000-5300000)
            
        case 5700000..<6200000: //500000
            UserDefaults.standard.set(51, forKey: "level")
            UserDefaults.standard.set(6200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5700000))/Float(6200000-5700000)
            
        case 6200000..<6700000: //500000
            UserDefaults.standard.set(52, forKey: "level")
            UserDefaults.standard.set(6700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-6200000))/Float(6700000-6200000)
            
        case 6700000..<7200000: //500000
            UserDefaults.standard.set(53, forKey: "level")
            UserDefaults.standard.set(7200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-6700000))/Float(7200000-6700000)
            
        case 7200000..<7700000: //500000
            UserDefaults.standard.set(54, forKey: "level")
            UserDefaults.standard.set(7700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7200000))/Float(7700000-7200000)
            
        case 7700000..<8200000: //500000
            UserDefaults.standard.set(55, forKey: "level")
            UserDefaults.standard.set(8200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7700000))/Float(8200000-7700000)
            
        case 8200000..<8700000: //500000
            UserDefaults.standard.set(56, forKey: "level")
            UserDefaults.standard.set(8700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8200000))/Float(8700000-8200000)
            
        case 8700000..<9200000: //500000
            UserDefaults.standard.set(57, forKey: "level")
            UserDefaults.standard.set(9200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8700000))/Float(9200000-8700000)
            
        case 9200000..<9700000: //500000
            UserDefaults.standard.set(58, forKey: "level")
            UserDefaults.standard.set(9700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-9200000))/Float(9700000-9200000)
            
        case 9700000..<10200000: //500000
            UserDefaults.standard.set(59, forKey: "level")
            UserDefaults.standard.set(10200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-9700000))/Float(10200000-9700000)
            
        case 10200000..<11000000: //600000
            UserDefaults.standard.set(60, forKey: "level")
            UserDefaults.standard.set(11000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-10200000))/Float(11000000-10200000)
            
        case 11000000..<12000000: //1000000
            UserDefaults.standard.set(61, forKey: "level")
            UserDefaults.standard.set(12000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-11000000))/Float(12000000-11000000)
            
        case 12000000..<13000000: //1000000
            UserDefaults.standard.set(62, forKey: "level")
            UserDefaults.standard.set(13000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-12000000))/Float(13000000-12000000)
            
        case 13000000..<14000000: //1000000
            UserDefaults.standard.set(63, forKey: "level")
            UserDefaults.standard.set(14000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-13000000))/Float(14000000-13000000)
            
        case 14000000..<15000000: //1000000
            UserDefaults.standard.set(64, forKey: "level")
            UserDefaults.standard.set(15000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-14000000))/Float(15000000-14000000)
            
        case 15000000..<16000000: //1000000
            UserDefaults.standard.set(65, forKey: "level")
            UserDefaults.standard.set(16000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-15000000))/Float(16000000-15000000)
            
        case 16000000..<17000000: //1000000
            UserDefaults.standard.set(66, forKey: "level")
            UserDefaults.standard.set(17000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-16000000))/Float(17000000-16000000)
            
        case 17000000..<18000000: //1000000
            UserDefaults.standard.set(67, forKey: "level")
            UserDefaults.standard.set(18000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-17000000))/Float(18000000-17000000)
            
        case 18000000..<19000000: //1000000
            UserDefaults.standard.set(68, forKey: "level")
            UserDefaults.standard.set(19000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-18000000))/Float(19000000-18000000)
            
        case 19000000..<20000000: //1000000
            UserDefaults.standard.set(69, forKey: "level")
            UserDefaults.standard.set(20000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-19000000))/Float(20000000-19000000)
            
        case 20000000..<22000000: //2000000 //20million
            UserDefaults.standard.set(70, forKey: "level")
            UserDefaults.standard.set(22000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-20000000))/Float(22000000-20000000)
            
        case 22000000..<24000000: //2000000
            UserDefaults.standard.set(71, forKey: "level")
            UserDefaults.standard.set(24000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-22000000))/Float(24000000-22000000)
            
        case 24000000..<26000000: //2000000
            UserDefaults.standard.set(72, forKey: "level")
            UserDefaults.standard.set(26000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-24000000))/Float(26000000-24000000)
            
        case 26000000..<28000000: //2000000
            UserDefaults.standard.set(73, forKey: "level")
            UserDefaults.standard.set(28000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-26000000))/Float(28000000-26000000)
            
        case 28000000..<30000000: //2000000
            UserDefaults.standard.set(74, forKey: "level")
            UserDefaults.standard.set(30000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-28000000))/Float(30000000-28000000)
            
        case 30000000..<32000000: //2000000
            UserDefaults.standard.set(75, forKey: "level")
            UserDefaults.standard.set(32000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-30000000))/Float(32000000-30000000)
            
        case 32000000..<34000000: //2000000
            UserDefaults.standard.set(76, forKey: "level")
            UserDefaults.standard.set(34000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-32000000))/Float(34000000-32000000)
            
        case 34000000..<36000000: //2000000
            UserDefaults.standard.set(77, forKey: "level")
            UserDefaults.standard.set(36000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-34000000))/Float(36000000-34000000)
            
        case 36000000..<38000000: //2000000
            UserDefaults.standard.set(78, forKey: "level")
            UserDefaults.standard.set(38000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-36000000))/Float(38000000-36000000)
            
        case 38000000..<40000000: //2000000
            UserDefaults.standard.set(79, forKey: "level")
            UserDefaults.standard.set(40000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-38000000))/Float(40000000-38000000)
            
        case 40000000..<42000000: //2000000
            UserDefaults.standard.set(80, forKey: "level")
            UserDefaults.standard.set(42000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-40000000))/Float(42000000-40000000)
            
        case 42000000..<44000000: //2000000
            UserDefaults.standard.set(81, forKey: "level")
            UserDefaults.standard.set(44000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-42000000))/Float(44000000-42000000)
            
        case 44000000..<46000000: //2000000
            UserDefaults.standard.set(82, forKey: "level")
            UserDefaults.standard.set(46000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-44000000))/Float(46000000-44000000)
            
        case 46000000..<48000000: //2000000
            UserDefaults.standard.set(83, forKey: "level")
            UserDefaults.standard.set(48000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-46000000))/Float(48000000-46000000)
            
        case 48000000..<49000000: //1000000
            UserDefaults.standard.set(84, forKey: "level")
            UserDefaults.standard.set(49000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-48000000))/Float(49000000-48000000)
            
        case 49000000..<50000000: //1000000
            UserDefaults.standard.set(85, forKey: "level")
            UserDefaults.standard.set(50000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-49000000))/Float(50000000-49000000)
            
        case 50000000..<52000000: //2000000
            UserDefaults.standard.set(86, forKey: "level")
            UserDefaults.standard.set(52000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-50000000))/Float(52000000-50000000)
            
        case 52000000..<54000000: //2000000
            UserDefaults.standard.set(87, forKey: "level")
            UserDefaults.standard.set(54000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-52000000))/Float(54000000-52000000)
            
        case 54000000..<56000000: //2000000
            UserDefaults.standard.set(88, forKey: "level")
            UserDefaults.standard.set(56000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-54000000))/Float(56000000-54000000)
            
        case 56000000..<58000000: //2000000
            UserDefaults.standard.set(89, forKey: "level")
            UserDefaults.standard.set(58000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-56000000))/Float(58000000-56000000)
            
        case 58000000..<60000000: //2000000
            UserDefaults.standard.set(90, forKey: "level")
            UserDefaults.standard.set(60000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-58000000))/Float(60000000-58000000)
            
        case 60000000..<64000000: //4000000
            UserDefaults.standard.set(91, forKey: "level")
            UserDefaults.standard.set(64000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-60000000))/Float(64000000-60000000)
            
        case 64000000..<68000000: //4000000
            UserDefaults.standard.set(92, forKey: "level")
            UserDefaults.standard.set(68000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-64000000))/Float(68000000-64000000)
            
        case 68000000..<72000000: //4000000
            UserDefaults.standard.set(93, forKey: "level")
            UserDefaults.standard.set(72000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-68000000))/Float(72000000-68000000)
            
        case 72000000..<76000000: //4000000
            UserDefaults.standard.set(94, forKey: "level")
            UserDefaults.standard.set(76000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-72000000))/Float(76000000-72000000)
            
        case 76000000..<80000000: //4000000
            UserDefaults.standard.set(95, forKey: "level")
            UserDefaults.standard.set(80000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-76000000))/Float(80000000-76000000)
            
        case 80000000..<85000000: //5000000
            UserDefaults.standard.set(96, forKey: "level")
            UserDefaults.standard.set(85000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-80000000))/Float(85000000-80000000)
            
        case 85000000..<90000000: //5000000
            UserDefaults.standard.set(97, forKey: "level")
            UserDefaults.standard.set(90000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-85000000))/Float(90000000-85000000)
            
        case 90000000..<95000000: //5000000
            UserDefaults.standard.set(98, forKey: "level")
            UserDefaults.standard.set(95000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-90000000))/Float(95000000-90000000)
            
        case 95000000..<100000000: //5000000
            UserDefaults.standard.set(99, forKey: "level")
            UserDefaults.standard.set(100000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-95000000))/Float(100000000-95000000)
            
            
        case 100000000..<676000000:
            UserDefaults.standard.set(100, forKey: "level")
            UserDefaults.standard.set(676000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-100000000))/Float(676000000-100000000)
            
        case 676000000..<2147483646:
            UserDefaults.standard.set(676, forKey: "level")
            UserDefaults.standard.set(0, forKey: "needPoint")
            return 1.0

        default:
            UserDefaults.standard.set(0, forKey: "level")
            return 1.0
            
        }
    }
}
