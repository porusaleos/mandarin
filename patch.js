const fs = require('fs');
const f = 'C:\\Users\\User\\Downloads\\mandarin\\index.html';
let c = fs.readFileSync(f, 'utf8');
const origLen = c.length;

function patch(name, search, replace) {
  if (c.includes(search)) {
    c = c.replace(search, replace);
    console.log(`✓ ${name}`);
  } else {
    console.log(`✗ ${name} - NOT FOUND`);
    // Show closest match hint
    const words = search.substring(0, 40);
    const idx = c.indexOf(words);
    console.log(`  Hint: "${words}" found at: ${idx}`);
  }
}

// PATCH 1: path() - better streak visual + configurable XP goal
patch('P1: streak fire + xp goal',
  `<b>${'${st.streak}'}</b> hari beruntun, <b>${'${st.xp}'}</b> XP<div class="bar" style="margin-top:8px"><i style="width:${'${Math.min(100,(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)*100/30)}'}%"></i></div><small>Target harian: 30 XP</small>`,
  `<div style="display:flex;justify-content:space-between;align-items:center"><b style="font-size:1.5rem">${'${st.streak>=7?"🔥🔥":st.streak>=3?"🔥":""}'}${'${st.streak}'}</b><span> hari beruntun &nbsp; <b>${'${st.xp}'}</b> XP</span><small class="mu">${'${rk(st.xp)}'}</small></div><div class="bar" style="margin-top:8px"><i style="width:${'${Math.min(100,(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)*100/(st.xpgoal||30))}'  }%"></i></div><small>Harian: ${'${st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0}'}/${'${st.xpgoal||30}'} XP ${'${(st.td&&st.td.d==new Date().toISOString().slice(0,10)?st.td.x:0)>=(st.xpgoal||30)?"🎉 Tercapai!":""}'}</small>`
);

// PATCH 2: Add XP goal setting in home/profile section (before speed setting)
patch('P2: XP goal setting UI',
  `<p class="mu">Kecepatan audio</p><div class="acts">${'${'}[[.6,'Pelan'],[.8,'Normal'],[1,'Cepat']].map`,
  `<p class="mu">Target XP harian</p><div class="acts">${'${'}[[10,'10'],[20,'20'],[30,'30'],[50,'50'],[100,'100']].map(([v,n])=>\`<button class="chip \${(st.xpgoal||30)==v?'on':''}" onclick="setGoal(\${v})">\${n} XP</button>\`).join('')${'}'}</div><p class="mu">Kecepatan audio</p><div class="acts">${'${'}[[.6,'Pelan'],[.8,'Normal'],[1,'Cepat']].map`
);

// PATCH 3: Add setGoal function
patch('P3: setGoal function',
  `function ss(v){st.sp=v;sv();draw();say('你好，欢迎学习汉语')}`,
  `function ss(v){st.sp=v;sv();draw();say('你好，欢迎学习汉语')}
function setGoal(v){st.xpgoal=v;sv();draw()}`
);

// PATCH 4: Expand tone training with more sets
patch('P4: more tone sets',
  `const TN=[['妈麻马骂','mā má mǎ mà'],['八拔把爸','bā bá bǎ bà'],['书熟属树','shū shú shǔ shù'],['衣姨椅易','yī yí yǐ yì'],['通同统痛','tōng tóng tǒng tòng']];`,
  `const TN=[['妈麻马骂','mā má mǎ mà'],['八拔把爸','bā bá bǎ bà'],['书熟属树','shū shú shǔ shù'],['衣姨椅易','yī yí yǐ yì'],['通同统痛','tōng tóng tǒng tòng'],['飞肥废废','fēi féi fěi fèi'],['西席洗系','xī xí xǐ xì'],['高巢搞告','gāo gáo gǎo gào'],['多磨抹墨','duō duó duǒ duò'],['开皑凯铠','kāi kái kǎi kài'],['喝河赫贺','hē hé hě hè'],['中虫肿众','zhōng zhóng zhǒng zhòng'],['刚钢港杠','gāng gáng gǎng gàng'],['他踏塔踏','tā tá tǎ tà']];`
);

// PATCH 5: Expand ETY (mnemonics) with more hanzi
const etyStart = c.indexOf("const ETY=[['好'");
const etyEnd = c.indexOf("];\n/* bagikan progres");
if (etyStart > 0 && etyEnd > 0) {
  const newEty = `const ETY=[
['好','女 (nǚ, wanita) + 子 (zǐ, anak): wanita bersama anaknya = baik, bagus.','女 (woman) + 子 (child): woman with child = good.'],
['明','日 (rì, matahari) + 月 (yuè, bulan): matahari dan bulan = terang, cerah.','日 (sun) + 月 (moon) = bright, clear.'],
['休','人 (rén, orang) + 木 (mù, pohon): orang bersandar di pohon = istirahat.','人 (person) + 木 (tree): person leaning on tree = rest.'],
['森','Tiga 木 (mù, pohon) bertumpuk = hutan lebat.','Three 木 (trees) = dense forest.'],
['安','宀 (mián, atap) + 女 (nǚ, wanita): wanita aman di bawah atap = tenteram, aman.','宀 (roof) + 女 (woman): woman safe under roof = peace.'],
['家','宀 (mián, atap) + 豕 (shǐ, babi): rumah dengan ternak = rumah, keluarga.','宀 (roof) + 豕 (pig): house with livestock = home, family.'],
['看','手 (shǒu, tangan) di atas 目 (mù, mata): tangan menaungi mata = melihat.','手 (hand) over 目 (eye): shading eyes = to look.'],
['男','田 (tián, ladang) + 力 (lì, tenaga): mencurahkan tenaga di ladang = laki-laki.','田 (field) + 力 (strength): strength in field = man.'],
['想','相 (xiāng) + 心 (xīn, hati): apa yang ada di dalam hati = ingin, berpikir, rindu.','相 + 心 (heart): what is in the heart = want, think, miss.'],
['爱','Ada 心 (xīn, hati) di tengahnya = perasaan cinta yang dalam.','Has 心 (heart) in the middle = love.'],
['妈','女 (nǚ, wanita) + 马 (mǎ, fonetik): ibu yang kuat.','女 (woman) + 马 (mǎ, phonetic) = mom.'],
['鸣','口 (kǒu, mulut) + 鸟 (niǎo, burung): burung berkicau.','口 (mouth) + 鸟 (bird): bird making sounds = to chirp.'],
['字','宀 (mián, atap) + 子 (zǐ, anak): anak belajar menulis di bawah atap = karakter.','宀 (roof) + 子 (child): children learning to write = character.'],
['学','Bagian atas = tangan yang mengajar; 子 (anak) di bawah = anak belajar.','Upper = teaching hands; 子 (child) below = child learning = to study.'],
['心','Bentuk asli seperti jantung dengan tiga titik = hati, pikiran.','Original form like a heart with three dots = heart, mind.'],
['水','Bentuk asli: aliran air di sungai = air.','Original: river current = water.'],
['山','Tiga puncak gunung yang berdiri = gunung.','Three mountain peaks = mountain.'],
['日','Lingkaran matahari dengan titik di tengah = matahari, hari.','Circle of sun with center dot = sun, day.'],
['月','Bulan sabit dengan garis = bulan (benda langit / kalender).','Crescent moon with lines = moon, month.'],
['木','Pohon: batang tegak, akar ke bawah, dahan ke atas = kayu.','Tree: trunk, roots below, branches above = wood, tree.'],
['火','Lidah-lidah api menjulur ke atas = api.','Tongues of flame rising = fire.'],
['大','Orang berdiri dengan tangan terentang = besar.','Person standing arms wide = big, large.'],
['小','Titik kecil di kanan-kiri = kecil.','Small dots on either side = small.'],
['口','Kotak terbuka = mulut yang menganga.','Open square = gaping mouth.'],
['人','Siluet orang berjalan dari samping = orang.','Side silhouette of walking person = person.'],
['力','Lengan otot yang melengkung = kekuatan.','Flexing muscular arm = strength.'],
['手','Lima jari dengan garis telapak = tangan.','Five fingers with palm lines = hand.'],
['目','Mata manusia dirotasi tegak dengan pupil = mata.','Human eye rotated vertical = eye.'],
['耳','Bentuk mirip telinga yang terlipat = telinga.','Folded ear shape = ear.'],
['土','Gundukan tanah di atas garis datar = tanah.','Mound of earth above flat line = earth, soil.']
]`;
  c = c.substring(0, etyStart) + newEty + c.substring(etyEnd);
  console.log('✓ P5: expanded ETY');
} else {
  console.log(`✗ P5: ETY not found, start=${etyStart}, end=${etyEnd}`);
}

// PATCH 6: Improve lety() function with categories and better layout
const idx6 = c.indexOf('function lety()');
const end6 = c.indexOf('/* bagikan progres */');
if (idx6 > 0 && end6 > 0) {
  const newLety = `function lety(){
const list0=ETY.filter(e=>['好','明','休','男','爱','妈','字','学','心','水','山','日','月','木','火','大','小','口','人','力'].includes(e[0]));
const list1=ETY.filter(e=>['看','想','安','家','鸣','手','目','耳','土','森'].includes(e[0]));
let etyCat=window._etyCat||0;
function renderEty(){
  window._etyCat=etyCat;
  const list=etyCat==0?list0:etyCat==1?list1:ETY;
  document.getElementById('ety-list').innerHTML=list.map(e=>\`<section class="card" style="display:flex;gap:14px;align-items:center;cursor:pointer" onclick="say('\${e[0]}')" title="Ketuk untuk mendengar"><div class="zh" style="font-size:3.5rem;line-height:1;min-width:60px;text-align:center">\${e[0]}</div><div style="flex:1"><p style="margin:.2rem 0;font-size:.9rem">\${st.lang=='en'?e[2]:e[1]}</p><small class="mu py2" style="font-size:.78rem">🔊 Ketuk hanzi</small></div></section>\`).join('');
}
app.innerHTML=\`\${bk0()}<h2>Asal-usul & Mnemonik Hanzi</h2><p class="mu">Komponen pembentuk membantu hafalan. Ketuk hanzi untuk mendengar.</p><div style="display:flex;gap:6px;margin:8px 0 12px;overflow-x:auto"><button class="chip \${etyCat==0?'on':''}" onclick="etyCat=0;renderEty()">HSK 1 Dasar (\${list0.length})</button><button class="chip \${etyCat==1?'on':''}" onclick="etyCat=1;renderEty()">HSK 2–3 (\${list1.length})</button><button class="chip \${etyCat==2?'on':''}" onclick="etyCat=2;renderEty()">Semua (\${ETY.length})</button></div><div id="ety-list"></div>\`;
renderEty();
}
`;
  c = c.substring(0, idx6) + newLety + c.substring(end6);
  console.log('✓ P6: improved lety()');
} else {
  console.log(`✗ P6: lety not found idx6=${idx6}, end6=${end6}`);
}

// PATCH 7: Improve share card (cdraw) - better design
const idx7 = c.indexOf('function cdraw()');
const end7 = c.indexOf('\nfunction shr()');
if (idx7 > 0 && end7 > 0) {
  const newCdraw = `function cdraw(){
const cv=document.getElementById('cv');if(!cv)return;
const ctx=cv.getContext('2d'),e=st.lang=='en',n=W.filter(w=>(st.m[w.h]||0)>=3).length;
ctx.clearRect(0,0,600,340);
// Background
ctx.fillStyle='#15130E';ctx.fillRect(0,0,600,340);
// Top accent
ctx.fillStyle='#C4301A';ctx.fillRect(0,0,600,8);
// Faint BG hanzi
ctx.font='160px "Noto Serif SC",serif';ctx.fillStyle='rgba(196,48,26,0.08)';
ctx.textAlign='right';ctx.fillText('学',580,320);ctx.textAlign='left';
// App label
ctx.font='bold 11px sans-serif';ctx.fillStyle='#9B968A';ctx.letterSpacing='0.1em';
ctx.fillText('BELAJAR MANDARIN · HSK 1–4',36,36);
// Big hanzi
ctx.font='bold 90px "Noto Serif SC",serif';ctx.fillStyle='#FF6B4B';
ctx.fillText('学',36,130);
// Streak fire badge
const fire=st.streak>=7?'🔥🔥':st.streak>=3?'🔥':'';
ctx.font='bold 24px sans-serif';ctx.fillStyle='#EDE9DE';
ctx.fillText((e?'My Mandarin Progress':'Progres Mandarin-ku'),150,72);
ctx.font='15px sans-serif';ctx.fillStyle='#9B968A';
ctx.fillText(fire+' '+rk(st.xp),150,100);
// Divider
ctx.strokeStyle='rgba(255,255,255,0.08)';ctx.lineWidth=1;
ctx.beginPath();ctx.moveTo(36,145);ctx.lineTo(564,145);ctx.stroke();
// Stats
[[st.streak||0,e?'day streak':'hari beruntun'],[st.xp||0,'XP'],[n,e?'words':'kata hafal']].forEach((a,i)=>{
  const x=36+i*185;
  ctx.font='bold 48px "Noto Serif SC",serif';ctx.fillStyle='#EDE9DE';
  ctx.fillText(String(a[0]),x,215);
  ctx.font='13px sans-serif';ctx.fillStyle='#9B968A';
  ctx.fillText(a[1],x,240);
});
// Bottom hashtag
ctx.font='bold 12px sans-serif';ctx.fillStyle='#C4301A';
ctx.fillText('#BelajarMandarin',36,324);
// Date
ctx.textAlign='right';ctx.fillStyle='#9B968A';ctx.font='11px sans-serif';
ctx.fillText(new Date().toLocaleDateString('id-ID'),564,324);ctx.textAlign='left';
}
`;
  c = c.substring(0, idx7) + newCdraw + c.substring(end7);
  console.log('✓ P7: improved cdraw()');
} else {
  console.log(`✗ P7: cdraw not found idx7=${idx7}, end7=${end7}`);
}

// PATCH 8: streak milestone notification
patch('P8: streak milestone in gain()',
  `function mk(w,ok){st.m[w.h]=Math.max(0,(st.m[w.h]||0)+(ok?1:-1));srs(w,ok);sv()}`,
  `function mk(w,ok){st.m[w.h]=Math.max(0,(st.m[w.h]||0)+(ok?1:-1));srs(w,ok);sv()}
function checkStreakMilestone(){const ms=[3,7,14,30,60,100];if(ms.includes(st.streak)){tt(st.streak>=30?'🏆 '+st.streak+' hari berturut! Luar biasa!':st.streak>=7?'🔥 '+st.streak+' hari berturut! Terus semangat!':'⭐ '+st.streak+' hari berturut! Bagus!')}}`
);

// PATCH 9: call checkStreakMilestone in gain()
patch('P9: call milestone check in gain()',
  `st.td.x+=Math.round(n);st.hx=st.hx||{};st.hx[t]=(st.hx[t]||0)+Math.round(n);
sv();if(n>=1)xpop(Math.round(n))`,
  `st.td.x+=Math.round(n);st.hx=st.hx||{};st.hx[t]=(st.hx[t]||0)+Math.round(n);
if(st.last!==t&&st.streak>1)checkStreakMilestone();
sv();if(n>=1)xpop(Math.round(n))`
);

// PATCH 10: Add i18n for new strings
patch('P10: i18n additions',
  `Object.assign(EN,{"Alat Bantu":"Study Tools"`,
  `Object.assign(EN,{"setGoal":"setGoal","Target XP harian":"Daily XP Goal","Harian:":"Daily:"});
Object.assign(EN,{"Alat Bantu":"Study Tools"`
);

console.log(`\nOriginal length: ${origLen}`);
console.log(`Final length: ${c.length}`);
console.log(`Delta: +${c.length - origLen} chars`);

fs.writeFileSync(f, c, 'utf8');
console.log('✓ File written successfully!');
