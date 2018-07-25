#写地图数据
name = '南区'
map_grid_id="02"
lng="114.30984"
lat="30.44098"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.lat = lat
a.lng = lng
a.save
end
南区: center = [114.30984,30.44098]
1:  {lon: 114.30726491893, lat: 30.446467914883} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529439369708"
name = '宿舍楼1栋'
map_grid_id="529439369708"
lng="114.30739902938"
lat="30.446146049801"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
2:  {lon: 114.30739902938, lat: 30.446146049801} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529445369669"
name = '宿舍楼2栋'
lng="114.30739902938"
lat="30.446146049801"
                      529445369669
map_grid_id="529445369669"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
3:   {lon: 114.30742585147, lat: 30.445765176121} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529452369624"
name = '宿舍楼3栋'
lng="114.30742585147"
lat="30.445765176121"
                      529452369624
map_grid_id="529452369624"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
4:  {lon: 114.30754923309, lat: 30.445384302441} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529461369584"
name = '宿舍楼4栋'
lng="114.30754923309"
lat="30.445384302441"
map_grid_id="529461369584"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
5:  {lon: 114.30757069076, lat: 30.445078530613} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529472369546"
name = '宿舍楼5栋'
lng="114.30757069076"
lat="30.445078530613"
map_grid_id="529472369546"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
6:   {lon: 114.3076726147, lat: 30.444686928097} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529484369505"
name = '宿舍楼6栋'
lng="114.3076726147"
lat="30.444686928097"
map_grid_id="529484369505"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
7:   {lon: 114.30789969936, lat: 30.444204130474} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529496369466"
name = '宿舍楼7栋'
lng="114.30789969936"
lat="30.444204130474"
map_grid_id="529496369466"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
8:  {lon: 114.30826806511, lat: 30.443989553753} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529510369427"
name = '宿舍楼8栋'
lng="114.30826806511"
lat="30.443989553753"
map_grid_id="529510369427"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
9:  {lon: 114.30816077674, lat: 30.443624773327} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529525369389"
name = '宿舍楼9栋'
lng="114.30816077674"
lat="30.443624773327"
map_grid_id="529525369389"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
10:{lon: 114.30858993019, lat: 30.443286814992} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529541369351"
name = '宿舍楼10栋'
lng="114.30858993019"
lat="30.443286814992"
map_grid_id="529541369351"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
      {lon: 114.3085952946, lat: 30.442938127819} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529558369313"
11: {lon: 114.3085040995, lat: 30.442954221074} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529558369313"
name = '宿舍楼11栋'
lng="114.3085040995"
lat="30.442954221074"
map_grid_id="529558369313"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
PhysicalGrid.where(:lvl=>3).collect(&:name).uniq
     {lon: 114.31139552081, lat: 30.44048658878} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529862369067"
12:{lon: 114.31149476257, lat: 30.440631428065} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529862369067"
name = '宿舍楼12栋'
lng="114.31149476257"
lat="30.440631428065"
map_grid_id="529862369067"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
13: {lon: 114.31182735649, lat: 30.440403440299} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529895369044"
name = '宿舍楼13栋'
lng="114.31182735649"
lat="30.440403440299"
map_grid_id="529895369044"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
14:{lon: 114.31215190378, lat: 30.440162041488} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529928369023"
name = '宿舍楼14栋'
lng="114.31215190378"
lat="30.440162041488"
map_grid_id="529928369023"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
15: {lon: 114.31247108665, lat: 30.43996355802} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529962369000"
name = '宿舍楼15栋'
lng="114.31247108665"
lat="30.43996355802"
map_grid_id="529962369000"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
16: {lon: 114.31288951126, lat: 30.439794578853} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:529995368978"
name = '宿舍楼16栋'
lng="114.31288951126"
lat="30.439794578853"
map_grid_id="529995368978"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
     {lon: 114.31327306712, lat: 30.439580002133} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530028368956"
17:{lon: 114.31320869413, lat: 30.439604142013} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530028368956"
name = '宿舍楼17栋'
lng="114.31320869413"
lat="30.439604142013"
map_grid_id="530028368956"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
18:{lon: 114.31357615676, lat: 30.439472713771} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530062368935"
name = '宿舍楼18栋'
lng="114.31357615676"
lat="30.439472713771"
map_grid_id="530062368935"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
19:{lon: 114.31389265743, lat: 30.439188399615} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530096368913"
name = '宿舍楼19栋'
lng="114.31389265743"
lat="30.439188399615"
map_grid_id="530096368913"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
20:{lon: 114.31431108203, lat: 30.439056971374} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530129368891"
name = '宿舍楼20栋'
lng="114.31431108203"
lat="30.439056971374"
map_grid_id="530129368891"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
21:{lon: 114.31461148944, lat: 30.438783386054} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530163368869"
name = '宿舍楼21栋'
lng="114.31461148944"
lat="30.438783386054"
map_grid_id="530163368869"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
     {lon: 114.31490921462, lat: 30.438566127126} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530196368847"
22:{lon: 114.31498163429, lat: 30.438582220378} "feature.data.WGBM:420111007221005" "feature.data.FWDBM:530196368847"
name = '宿舍楼22栋'
lng="114.31498163429"
lat="30.438582220378"
map_grid_id="530196368847"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end


北区: center = [114.31673,30.47877] 
name = '北区'
map_grid_id="01"
lng="114.31673"
lat="30.47877"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.lat = lat
a.lng = lng
a.save
end
101:{lon: 114.31304716661, lat: 30.480390169482} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530128373465"
name = '宿舍楼A栋'
lng="114.31304716661"
lat="30.480390169482"
map_grid_id="530128373465"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
102:{lon: 114.31467794969, lat: 30.480025389056} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530149373430"
name = '宿舍楼B栋'
lng="114.31467794969"
lat="30.480025389056"
map_grid_id="530149373430"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
103:{lon: 114.31505614116, lat: 30.48031506763} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530184373465"
name = '宿舍楼C栋'
lng="114.31505614116"
lat="30.48031506763"
map_grid_id="530184373465"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
104:{lon: 114.31528412893, lat: 30.480028071265} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530213373430"
name = '宿舍楼D栋'
lng="114.31528412893"
lat="30.480028071265"
map_grid_id="530213373430"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
105:{lon: 114.31565695598, lat: 30.480352618556} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530246373464"
name = '宿舍楼E栋'
lng="114.31565695598"
lat="30.480352618556"
map_grid_id="530246373464"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end
106:{lon: 114.31645357206, lat: 30.480347254138} "feature.data.WGBM:420111007007022" "feature.data.FWDBM:530334373464"
name = '宿舍楼F栋'
lng="114.31645357206"
lat="30.480347254138"
map_grid_id="530334373464"
g = PhysicalGrid.where(:name=>name).first
gs = g.get_grid_ids
gs.each do |x|
a = PhysicalGrid.where(:grid_id=>x).first
a.map_grid_id = map_grid_id
a.save
end

#GridStudentInfo造数据
# def self.create_test_data
  y = 0
  PhysicalGrid.where(:lvl=>5).find_each do |x|
    students = UndergraduateStudent.offset(y).first(6)
    y += 6
    students.each do |s|
      if GridStudentInfo.where(:sno=>s.sno).blank?
        obj = GridStudentInfo.new
        obj.grid_id = x.grid_id
        obj.sno = s.sno
        obj.save
      end
    end
  end
# end
select *  from undergraduate_students where wno not in (select sno wno from grid_student_infos);