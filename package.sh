#工作原理
#1.首先需要在程序中对info.plist添加一个渠道字段,用来区分是那个渠道.
#2.使用xcodebuild命令生成archive文件
#3.循环修改info.plist文件,修改渠道名.并倒出ipa
#4.删除临时文件

#Schema名称
schema="***"
#设置项目路径
work="**.xcworkspace"
#倒出存档
xcodebuild -workspace $work -scheme $schema -configuration Release archive -archivePath ./archive 

#work="/Users/bing/XCodeProjects/LearningBar/trunk/LearningBar/LearningBar.xcodeproj"
#xcodebuild -project $work -scheme $schema -configuration Release archive -archivePath ./archive 

channels=("91手机助手" "同步推" "PP助手")

for i in ${channels[@]}; do
	#修改info.plist文件
	/usr/libexec/PlistBuddy -c "Set :Channel ""$i" ./archive.xcarchive/Products/Applications/*.app/info.plist
	#删除当前已存在的包
	rm -Rf ./$i.ipa
	#倒出IPA
	xcodebuild -exportArchive —exportFormat ipa -archivePath ./archive.xcarchive -exportPath ./$i.ipa -exportWithOriginalSigningIdentity
done
#删除archive
rm -Rf ./archive.xcarchive

