$f = "C:\Users\User\Downloads\mandarin\index.html"
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
$origLen = $c.Length

# PATCH 1: path() - better streak visual + configurable XP goal
# Replace the streak/XP display in path()
$old1 = '<b>${st.streak}</b> hari beruntun, <b>${st.xp}</b> XP<div class="bar" style="margin-top:8px"><i style="width:${Math.min(100,(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)*100/30)}%"></i></div><small>Target harian: 30 XP</small>'
$new1 = '<div style="display:flex;justify-content:space-between;align-items:center"><b style="font-size:1.5rem">${st.streak>=7?''🔥🔥'':st.streak>=3?''🔥'':''''}<b>${st.streak}</b> hari beruntun</b><span class="mu">${rk(st.xp)} · ${st.xp} XP</span></div><div class="bar" style="margin-top:8px"><i style="width:${Math.min(100,(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)*100/(st.xpgoal||30))}%"></i></div><small>Harian: ${(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)}/${st.xpgoal||30} XP ${(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)>=(st.xpgoal||30)?''🎉 Tercapai!'':''''}</small>'
Write-Host "P1 found: $($c.Contains($old1))"
if ($c.Contains($old1)) { $c = $c.Replace($old1, $new1); Write-Host "P1 done" }

# PATCH 2: Profil - Add XP goal setting
$old2 = '<p class="mu">Kecepatan audio</p>'
$new2 = '<p class="mu">Target XP harian</p><div class="acts">${[[10,''10 XP''],[20,''20 XP''],[30,''30 XP''],[50,''50 XP''],[100,''100 XP'']].map(([v,n])=>`<button class="chip ${(st.xpgoal||30)==v?''on'':''''}" onclick="setGoal(${v})">${n}</button>`).join('''')}</div><p class="mu">Kecepatan audio</p>'
Write-Host "P2 found: $($c.Contains($old2))"
if ($c.Contains($old2)) { $c = $c.Replace($old2, $new2); Write-Host "P2 done" }

# PATCH 3: Add setGoal function after ss() function
$old3 = 'function ss(v){st.sp=v;sv();draw();say(''你好，欢迎学习汉语'')}'
$new3 = 'function ss(v){st.sp=v;sv();draw();say(''你好，欢迎学习汉语'')}
function setGoal(v){st.xpgoal=v;sv();draw()}'
Write-Host "P3 found: $($c.Contains($old3))"
if ($c.Contains($old3)) { $c = $c.Replace($old3, $new3); Write-Host "P3 done" }

# PATCH 4: Expand ETY (mnemonics) - replace the existing small list with extended one
$old4 = "const ETY=[['好','女 (wanita) + 子 (anak): wanita bersama anaknya = baik.','女 (woman) + 子 (child): a woman with her child = good.'],['明','日 (matahari) + 月 (bulan) = terang.','日 (sun) + 月 (moon) = bright.'],['休','人 (orang) + 木 (pohon): orang bersandar di pohon = istirahat.','人 (person) + 木 (tree): a person leaning on a tree = rest.'],['森','Tiga 木 (pohon) = hutan.','Three 木 (trees) = forest.'],['安','宀 (atap) + 女 (wanita): wanita di bawah atap = tenteram.','宀 (roof) + 女 (woman): a woman under a roof = peace.'],['家','宀 (atap) + 豕 (babi): rumah dengan ternak = rumah/keluarga.','宀 (roof) + 豕 (pig): a house with livestock = home/family.'],['看','手 (tangan) di atas 目 (mata): tangan menaungi mata = melihat.','手 (hand) over 目 (eye): shading the eyes = to look.'],['男','田 (ladang) + 力 (tenaga): tenaga di ladang = laki-laki.','田 (field) + 力 (strength): strength in the field = man.'],['想','相 (saling) + 心 (hati): isi hati = ingin/berpikir.','相 (each other) + 心 (heart): what is in the heart = want/think.'],['爱','Ada 心 (hati) di tengahnya = cinta.','Has 心 (heart) in the middle = love.'],['妈','女 (wanita) + 马 (mǎ, bunyi): ibu.','女 (woman) + 马 (mǎ, sound): mom.'],['鸣','口 (mulut) + 鸟 (burung): burung berkicau.','口 (mouth) + 鸟 (bird): a bird chirping.']];"
$new4 = "const ETY=[
['好','女 (nǚ, wanita) + 子 (zǐ, anak): wanita bersama anaknya = baik, bagus.','女 (woman) + 子 (child): a woman with her child = good.'],
['明','日 (rì, matahari) + 月 (yuè, bulan): matahari dan bulan = terang, cerah.','日 (sun) + 月 (moon) = bright, clear.'],
['休','人 (rén, orang) + 木 (mù, pohon): orang bersandar di pohon = istirahat.','人 (person) + 木 (tree): a person leaning on a tree = rest.'],
['森','Tiga 木 (mù, pohon) bertumpuk = hutan lebat.','Three 木 (trees) stacked = dense forest.'],
['安','宀 (mián, atap) + 女 (nǚ, wanita): wanita aman di bawah atap = tenteram, aman.','宀 (roof) + 女 (woman): a woman safe under a roof = peace, safety.'],
['家','宀 (mián, atap) + 豕 (shǐ, babi): rumah dengan ternak babi = rumah, keluarga.','宀 (roof) + 豕 (pig): a house with livestock = home, family.'],
['看','手 (shǒu, tangan) di atas 目 (mù, mata): tangan menaungi mata saat melihat jauh.','手 (hand) over 目 (eye): shading the eyes to look into the distance = to look, see.'],
['男','田 (tián, ladang) + 力 (lì, tenaga): mencurahkan tenaga di ladang = laki-laki.','田 (field) + 力 (strength): exerting strength in the field = man.'],
['想','相 (xiāng, saling) + 心 (xīn, hati): apa yang ada di dalam hati = ingin, berpikir, rindu.','相 (each other) + 心 (heart): what is in the heart = want, think, miss.'],
['爱','Ada 心 (xīn, hati) di tengahnya = perasaan cinta yang dalam.','Has 心 (heart) in the middle = deep feeling of love.'],
['妈','女 (nǚ, wanita) + 马 (mǎ, kuda — bunyi): ibu yang kuat.','女 (woman) + 马 (mǎ, phonetic): a strong woman = mom.'],
['鸣','口 (kǒu, mulut) + 鸟 (niǎo, burung): burung yang mengeluarkan suara dari mulutnya = berkicau.','口 (mouth) + 鸟 (bird): a bird making sounds = to chirp, cry (of animals).'],
['字','宀 (mián, atap) + 子 (zǐ, anak): anak-anak belajar menulis di bawah atap = karakter, huruf.','宀 (roof) + 子 (child): children learning to write = character, letter.'],
['学','Bagian atas = tangan mengajar; 子 (anak) di bawah = anak belajar.','Upper part = hands teaching; 子 (child) below = child learning = to study.'],
['心','Bentuk asli seperti jantung dengan tiga titik mewakili denyutan.','Originally shaped like a heart with three dots for pulsation = heart, mind.'],
['水','Bentuk asli: aliran air di sungai dengan percabangan = air.','Original form: river current with branches = water.'],
['山','Tiga puncak gunung yang berdiri = gunung.','Three mountain peaks standing = mountain.'],
['日','Lingkaran matahari dengan titik di tengah = matahari, hari.','Circle of the sun with a dot in the center = sun, day.'],
['月','Bulan sabit dengan garis = bulan (benda langit), bulan (kalender).','Crescent moon with lines = moon, month.'],
['木','Pohon dengan batang, akar ke bawah, dahan ke atas = kayu, pohon.','Tree with trunk, roots below, branches above = wood, tree.'],
['火','Lidah-lidah api yang menjulur ke atas = api.','Tongues of flame rising upward = fire.'],
['土','Gundukan tanah di atas garis datar = tanah, bumi.','A mound of earth above a flat line = earth, soil.'],
['大','Orang (人) berdiri dengan tangan terentang lebar = besar.','A person (人) standing with arms spread wide = big, large.'],
['小','Titik kecil di kanan-kiri garis tengah = kecil, sedikit.','Small dots on either side of a center line = small, little.'],
['口','Kotak terbuka: mulut yang menganga = mulut.','An open square: a gaping mouth = mouth.'],
['耳','Bentuk asli mirip telinga yang terlipat = telinga.','Original form resembling a folded ear = ear.'],
['目','Mata manusia yang dirotasi tegak dengan pupil = mata.','Human eye rotated vertical with pupil = eye.'],
['手','Lima jari dengan garis penghubung telapak = tangan.','Five fingers with palm connection lines = hand.'],
['力','Lengan otot yang melengkung = kekuatan, tenaga.','A flexing muscular arm = strength, power.'],
['人','Siluet orang berjalan dari samping = orang.','Side silhouette of a walking person = person, people.']
];"
Write-Host "P4 found: $($c.Contains($old4.Substring(0,50)))"
if ($c.Contains($old4.Substring(0,50))) {
  # Find and replace by locating the full ETY array
  $etyStart = $c.IndexOf("const ETY=[['好'")
  $etyEnd = $c.IndexOf("];`n/* bagikan progres")
  if ($etyStart -gt 0 -and $etyEnd -gt 0) {
    $c = $c.Substring(0, $etyStart) + $new4 + $c.Substring($etyEnd)
    Write-Host "P4 done (by position)"
  } else {
    Write-Host "P4 position not found, etyStart=$etyStart, etyEnd=$etyEnd"
  }
}

# PATCH 5: Expand tone training sets with more HSK words
$old5 = "const TN=[['妈麻马骂','mā má mǎ mà'],['八拔把爸','bā bá bǎ bà'],['书熟属树','shū shú shǔ shù'],['衣姨椅易','yī yí yǐ yì'],['通同统痛','tōng tóng tǒng tòng']];"
$new5 = "const TN=[['妈麻马骂','mā má mǎ mà'],['八拔把爸','bā bá bǎ bà'],['书熟属树','shū shú shǔ shù'],['衣姨椅易','yī yí yǐ yì'],['通同统痛','tōng tóng tǒng tòng'],['飞肥废废','fēi féi fěi fèi'],['西席洗系','xī xí xǐ xì'],['高巢搞告','gāo gáo gǎo gào'],['多磨抹墨','duō duó duǒ duò'],['开皑凯铠','kāi kái kǎi kài'],['喝河河贺','hē hé hě hè'],['中虫肿众','zhōng zhóng zhǒng zhòng'],['刚钢港杠','gāng gáng gǎng gàng'],['他踏塔踏','tā tá tǎ tà']];"
Write-Host "P5 found: $($c.Contains($old5))"
if ($c.Contains($old5)) { $c = $c.Replace($old5, $new5); Write-Host "P5 done" }

# PATCH 6: Improve lety() function - add search/filter and better layout
$old6 = "function lety(){app.innerHTML=`${bk0()}<h2>Asal-usul Hanzi</h2><p class=\"mu\">Ketuk hanzi untuk mendengar</p>`+ETY.map(e=>`<section class=\"card\" style=\"display:flex;gap:14px;align-items:center\"><div class=\"zh big\" style=\"cursor:pointer\" onclick=\"say('${e[0]}')\"></${e[0]}</div><p>${st.lang=='en'?e[2]:e[1]}</p></section>`).join('')}"
Write-Host "P6 checking..."
$idx6 = $c.IndexOf("function lety()")
Write-Host "lety at: $idx6"
if ($idx6 -gt 0) {
  $end6 = $c.IndexOf("/* bagikan progres */")
  Write-Host "end lety at: $end6"
  if ($end6 -gt 0) {
    $old6_actual = $c.Substring($idx6, $end6 - $idx6)
    $new6_actual = @"
function lety(){
const cats=[['HSK 1 (Dasar)',['好','明','休','男','爱','妈','字','学','心','水','山','日','月','木','火']],['HSK 2–3 (Menengah)',['看','想','安','家','鸣','大','小','口','耳','目','手','力','人','土','森']]];
let etyCat=0;
function renderEty(){
  const all=ETY;
  const list=etyCat==0?all.filter(e=>cats[0][1].includes(e[0])):etyCat==1?all.filter(e=>cats[1][1].includes(e[0])):all;
  document.getElementById('ety-list').innerHTML=list.map(e=>`<section class="card" style="display:flex;gap:14px;align-items:center;cursor:pointer" onclick="say('${e[0]}')"><div class="zh" style="font-size:3.5rem;line-height:1;min-width:60px;text-align:center;font-family:'Noto Serif SC',serif">${e[0]}</div><div><p style="margin:.2rem 0">${st.lang=='en'?e[2]:e[1]}</p><small class="mu">Ketuk untuk mendengar</small></div></section>`).join('');
}
app.innerHTML=`${bk0()}<h2>Asal-usul & Mnemonik Hanzi</h2><p class="mu">Komponen pembentuk hanzi membantu hafalan. Ketuk untuk mendengar.</p><div style="display:flex;gap:6px;margin:8px 0 12px;overflow-x:auto"><button class="chip ${etyCat==0?'on':''}" onclick="etyCat=0;renderEty()">HSK 1</button><button class="chip ${etyCat==1?'on':''}" onclick="etyCat=1;renderEty()">HSK 2–3</button><button class="chip ${etyCat==2?'on':''}" onclick="etyCat=2;renderEty()">Semua</button></div><div id="ety-list"></div>`;
renderEty();
}

"@
    $c = $c.Substring(0, $idx6) + $new6_actual + $c.Substring($end6)
    Write-Host "P6 done"
  }
}

# PATCH 7: Improve share card (cdraw) - add HSK level badge and streak fire
$old7 = "function cdraw(){const c=`$('#cv').getContext('2d'),e=st.lang=='en',n=W.filter(w=>(st.m[w.h]||0)>=3).length,T=(t,x,y,z,col)=>{c.fillStyle=col||'#EDE9DE';c.font=z+'px \"Noto Serif SC\",serif';c.fillText(t,x,y)};c.fillStyle='#15130E';c.fillRect(0,0,600,340);c.fillStyle='#C4301A';c.fillRect(0,0,600,8);T('学',36,120,90,'#FF6B4B');T(e?'My Mandarin Progress':'Progres Mandarin-ku',150,70,28);T('HSK 1–4',150,110,20,'#9B968A');[[st.streak||0,e?'day streak':'hari beruntun'],[st.xp||0,'XP'],[n,e?'words learned':'kata hafal']].forEach((a,i)=>{T(String(a[0]),36+i*190,240,56);T(a[1],36+i*190,280,18,'#9B968A')})}"
Write-Host "P7 found: $($c.Contains($old7.Substring(0,60)))"
$idx7 = $c.IndexOf("function cdraw()")
Write-Host "cdraw at: $idx7"
if ($idx7 -gt 0) {
  $end7 = $c.IndexOf("`nfunction shr()")
  Write-Host "end cdraw at: $end7"
  if ($end7 -gt 0) {
    $new7 = @"
function cdraw(){
const cv=document.getElementById('cv');if(!cv)return;
const ctx=cv.getContext('2d'),e=st.lang=='en',n=W.filter(w=>(st.m[w.h]||0)>=3).length;
const W2=600,H2=340;
// Background gradient
const grad=ctx.createLinearGradient(0,0,0,H2);
grad.addColorStop(0,'#1A1814');grad.addColorStop(1,'#0E0D0A');
ctx.fillStyle=grad;ctx.fillRect(0,0,W2,H2);
// Red accent bar top
ctx.fillStyle='#C4301A';ctx.fillRect(0,0,W2,6);
// Decorative hanzi background
ctx.font='160px "Noto Serif SC",serif';ctx.fillStyle='rgba(196,48,26,0.07)';
ctx.fillText('学',W2-180,H2-10);
// App name
ctx.font='bold 13px "Instrument Sans",sans-serif';ctx.fillStyle='#9B968A';
ctx.fillText('BELAJAR MANDARIN · HSK 1–4',36,38);
// Big hanzi
ctx.font='bold 90px "Noto Serif SC",serif';ctx.fillStyle='#FF6B4B';
ctx.fillText('学',36,130);
// Streak fire
const fire=st.streak>=7?'🔥🔥':st.streak>=3?'🔥':'';
ctx.font='bold 26px "Instrument Sans",sans-serif';ctx.fillStyle='#EDE9DE';
ctx.fillText((e?'My Mandarin Progress':'Progres Mandarin-ku'),150,72);
ctx.font='16px "Instrument Sans",sans-serif';ctx.fillStyle='#9B968A';
ctx.fillText(fire+' '+rk(st.xp),150,100);
// Stats
[[st.streak||0,e?'day streak':'hari beruntun'],[st.xp||0,'XP'],[n,e?'words':'kata hafal']].forEach((a,i)=>{
  const x=36+i*190;
  ctx.font='bold 52px "Noto Serif SC",serif';ctx.fillStyle='#EDE9DE';
  ctx.fillText(String(a[0]),x,230);
  ctx.font='14px "Instrument Sans",sans-serif';ctx.fillStyle='#9B968A';
  ctx.fillText(a[1],x,258);
});
// Bottom tag
ctx.font='12px "Instrument Sans",sans-serif';ctx.fillStyle='#C4301A';
ctx.fillText('#BelajarMandarin',36,H2-16);
}

"@
    $c = $c.Substring(0, $idx7) + $new7 + $c.Substring($end7)
    Write-Host "P7 done"
  }
}

# PATCH 8: i18n for new strings
$old8 = "Object.assign(EN,{\"Alat Bantu\":"
$new8_prefix = @"
Object.assign(EN,{"setGoal":"setGoal","Target XP harian":"Daily XP Goal","Harian:":"Daily:"});
Object.assign(EN,{"Alat Bantu & Mnemonik Hanzi":"Hanzi Origins & Mnemonics","HSK 1 (Dasar)":"HSK 1 (Basic)","HSK 2–3 (Menengah)":"HSK 2–3 (Intermediate)","Komponen pembentuk hanzi membantu hafalan. Ketuk untuk mendengar.":"Hanzi components help memorization. Tap to listen.","Ketuk untuk mendengar":"Tap to listen"});
Object.assign(EN,{"Alat Bantu":
"@
Write-Host "P8 found: $($c.Contains($old8))"
if ($c.Contains($old8)) { $c = $c.Replace($old8, $new8_prefix); Write-Host "P8 done" }

Write-Host "Final length: $($c.Length) (was $origLen)"
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "File written successfully!"
