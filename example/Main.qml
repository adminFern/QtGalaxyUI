import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"
Window {
    width: 650
    height: 480
    visible: true
    title: qsTr("Hello ccc")
    color: Theme.dark?Qt.rgba(0.32,0.32,0.32):"white"


    // 定义可用的图标集合
    property var availableIcons: [
        FluentIcons.q_Settings,
        FluentIcons.q_Home,
        FluentIcons.q_Globe,
        FluentIcons.q_MapPin,
        FluentIcons.q_City,
        FluentIcons.q_Flag,
        FluentIcons.q_Building,
        FluentIcons.q_Mountain,
        FluentIcons.q_River,
        FluentIcons.q_Wifi,
        FluentIcons.q_Video,
        FluentIcons.q_FavoriteList,
        FluentIcons.q_More,
        FluentIcons.q_Search,
        FluentIcons.q_Send,
        FluentIcons.q_Tree

    ]

    // 中国省份列表
    property var chineseProvinces: [
        "北京市", "天津市", "上海市", "重庆市", "河北省", "山西省", "辽宁省",
        "吉林省", "黑龙江省", "江苏省", "浙江省", "安徽省", "福建省", "江西省",
        "山东省", "河南省", "湖北省", "湖南省", "广东省", "海南省", "四川省",
        "贵州省", "云南省", "陕西省", "甘肃省", "青海省", "台湾省", "内蒙古自治区",
        "广西壮族自治区", "西藏自治区", "宁夏回族自治区", "新疆维吾尔自治区",
        "香港特别行政区", "澳门特别行政区"
    ]

    // 全球主要地区/国家列表
    property var globalRegions: [
        "美国", "加拿大", "墨西哥", "巴西", "阿根廷", "英国", "法国", "德国",
        "意大利", "西班牙", "葡萄牙", "荷兰", "比利时", "瑞士", "瑞典", "挪威",
        "芬兰", "丹麦", "冰岛", "俄罗斯", "乌克兰", "波兰", "日本", "韩国",
        "印度", "泰国", "越南", "马来西亚", "新加坡", "印度尼西亚", "菲律宾",
        "澳大利亚", "新西兰", "南非", "埃及", "肯尼亚", "摩洛哥", "沙特阿拉伯",
        "阿联酋", "土耳其", "以色列", "伊朗", "伊拉克"
    ]

    // 生成1万条随机数据
    property var regionData: {
        var data = [];
        var usedNames = {}; // 用于检查重复

        // 首先添加所有中国省份
        for (var i = 0; i < chineseProvinces.length; i++) {
            var province = chineseProvinces[i];
            data.push({
                          text: province,
                          icon: availableIcons[Math.floor(Math.random() * availableIcons.length)]
                      });
            usedNames[province] = true;
        }

        // 然后添加全球地区
        for (var j = 0; j < globalRegions.length; j++) {
            var region = globalRegions[j];
            data.push({
                          text: region,
                          icon: availableIcons[Math.floor(Math.random() * availableIcons.length)]
                      });
            usedNames[region] = true;
        }

        // 生成剩余数量的随机地区名称
        var cities = ["市", "城", "镇", "乡", "村", "区", "县"];
        var prefixes = ["东", "西", "南", "北", "新", "大", "小", "老", "古", "金", "银", "铜", "铁"];
        var suffixes = ["山", "河", "湖", "海", "江", "川", "林", "田", "原", "坡", "岭", "港", "湾"];

        while (data.length < 30) {
            // 生成随机地区名称
            var name;
            var attempt = 0;

            do {
                // 随机组合生成名称
                if (Math.random() > 0.5) {
                    name = prefixes[Math.floor(Math.random() * prefixes.length)] +
                            suffixes[Math.floor(Math.random() * suffixes.length)];
                } else {
                    name = prefixes[Math.floor(Math.random() * prefixes.length)] +
                            cities[Math.floor(Math.random() * cities.length)];
                }

                // 避免无限循环
                if (attempt++ > 100) {
                    name += Math.floor(Math.random() * 1000);
                }
            } while (usedNames[name]);

            usedNames[name] = true;

            data.push({
                          text: name,
                          icon: availableIcons[Math.floor(Math.random() * availableIcons.length)]
                      });
        }

        return data;
    }

    // 初始化模型
    ListModel {
        id: regionModel
    }

    Column{

        Row{
            padding: 5
            spacing: 6
            leftPadding: 5


            Button{
                height: 35
                width:68
                text: "浅色"
                onClicked:{
                    if(Theme.dark) {
                        Theme.ThemeType=Theme.Light

                    }
                }


            }
            Button{
                height: 35
                width:68
                text: "深色"
                onClicked:{
                    if(!Theme.dark) {
                        Theme.ThemeType=Theme.Dark
                    }
                }
            }
            Button{
                height: 35
                width:68
                text: "系统颜色"
                onClicked:Theme.ThemeType=Theme.System
            }
            Button{
                height: 35
                width:100
                text: "打开"
                onClicked:bobox.open()
            }
            Button{
                height: 35
                width:100
                text: "关闭"
                onClicked:bobox.close()
            }
            Button{
                height: 35
                width:100
                text: "清空"
                onClicked:bobox.clearAll()
            }
            Button{
                height: 35
                width:100
                text: "替换"

                onClicked:{
                    bobox.replaceItem(1,{text:"中国移动,替换了",icon:FluentIcons.q_Marker})
                }
            }
        }
        Row{

            Button{
                height: 35

                text: "删除当前选中项目"
                onClicked:bobox.removeCurrent()
            }
            Button{
                height: 35

                text: "头部插入"
                onClicked:bobox.addHeadItem({text:"中华人们共和国",icon:FluentIcons.q_Send})
            }
            Button{
                height: 35

                text: "尾部插入"
                onClicked:bobox.addendItem({text:"中国台湾省",icon:FluentIcons.q_Lock})
            }
            Button{
                height: 35

                text: "当前选中项"
                onClicked:console.log(bobox.currentIndex)
            }
            Button{
                height: 35

                text: "取指定文本"
                onClicked:{
                    console.log(bobox.getItemText(3))
                }
            }
            Button{
                height: 35

                text: "删除指定"
                onClicked:{
                    bobox.removeItem(3)

                }
            }
        }


    }
    QComboBox{
        id:bobox
        anchors.centerIn: parent

        onActivated: function(index) {
            console.log("选择了:", model.get(index).text, "图标:", model.get(index).icon)
        }
        Component.onCompleted: {
            for (var i = 0; i < regionData.length; i++) {
                regionModel.append(regionData[i]);
            }
            model = regionModel;
        }
    }

    Label{
        id:darktexe
        width: parent.width
        height: 30
        anchors.bottom: parent.bottom
        text: "当前的主题模式是否Dark："+Theme.dark

    }




}
