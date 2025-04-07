import QtQuick
import "../Controls"
import GalaxyUI
import QtQuick.Controls
Item {

    // 数据模型
    ListModel {
        id: randomDataModel
    }
    // 生成数据的函数
    function generateRandomData() {
        // 清空现有数据
        randomDataModel.clear();

        // 全球公司名称 (50+)
        const companiesGlobal = [
                                  "Google", "Apple", "Amazon", "Microsoft", "Tesla", "Meta", "Samsung", "Intel", "IBM", "Oracle",
                                  "Netflix", "Adobe", "Cisco", "Nvidia", "PayPal", "Uber", "Airbnb", "Twitter", "LinkedIn", "Zoom",
                                  "Spotify", "eBay", "HP", "Dell", "Sony", "Panasonic", "LG", "Nokia", "Volvo", "BMW", "Mercedes",
                                  "Toyota", "Honda", "Starbucks", "McDonald", "KFC", "Pepsi", "CocaCola", "Nike", "Adidas", "Puma",
                                  "Gucci", "LV", "Zara", "Uniqlo", "IKEA", "Walmart", "Target", "Costco", "FedEx", "DHL"
                              ];

        // 中国公司名称 (50+)
        const companiesChina = [
                                 "腾讯", "阿里巴巴", "百度", "华为", "字节跳动", "美团", "京东", "拼多多", "小米", "OPPO",
                                 "Vivo", "联想", "中兴", "大疆", "比亚迪", "蔚来", "小鹏", "理想", "格力", "海尔",
                                 "美的", "中国移动", "中国电信", "中国联通", "工商银行", "建设银行", "农业银行", "中国银行", "招商银行", "平安保险",
                                 "中国人寿", "中国石油", "中国石化", "中国建筑", "中国中铁", "中国交建", "顺丰", "中通", "申通", "韵达",
                                 "网易", "搜狐", "新浪", "携程", "同程", "滴滴", "快手", "B站", "爱奇艺", "知乎"
                             ];

        // 日常用语 (50+)
        const dailyPhrases = [
                               "你好世界", "今天天气", "早上好", "下午好", "晚上好", "周末愉快", "新年快乐", "生日快乐", "恭喜发财", "万事如意",
                               "心想事成", "身体健康", "工作顺利", "学业进步", "财源广进", "阖家幸福", "龙马精神", "一帆风顺", "步步高升", "吉祥如意",
                               "笑口常开", "青春永驻", "幸福美满", "平安喜乐", "福如东海", "寿比南山", "金玉满堂", "花开富贵", "年年有余", "大吉大利",
                               "招财进宝", "心想事成", "前程似锦", "飞黄腾达", "马到成功", "锦绣前程", "鹏程万里", "春风得意", "喜气洋洋", "欢天喜地",
                               "国泰民安", "风调雨顺", "五谷丰登", "六畜兴旺", "家和万事兴", "天作之合", "百年好合", "永结同心", "白头偕老", "早生贵子"
                           ];

        // 图标选项（随机选择）
        const icons = [Icons.Wifi, Icons.Connect, Icons.Cloud, Icons.Settings, Icons.Home,Icons.EMI,Icons.VPN,Icons.Phone, 0]; // 0 表示无图标

        // 生成 10,000 条数据
        for (let i = 0; i < 300; i++) {
            // 随机选择数据源（0: 日常用语, 1: 全球公司, 2: 中国公司）
            const dataSource = Math.floor(Math.random() * 3);
            let text;

            if (dataSource === 0) {
                text = dailyPhrases[Math.floor(Math.random() * dailyPhrases.length)];
            } else if (dataSource === 1) {
                text = companiesGlobal[Math.floor(Math.random() * companiesGlobal.length)];
            } else {
                text = companiesChina[Math.floor(Math.random() * companiesChina.length)];
            }

            // 确保文本长度为 7 字符（不足补空格）
            text = text.padEnd(7, " ").substring(0, 7);

            // 随机选择图标
            const icon = icons[Math.floor(Math.random() * icons.length)];

            // 添加到 ListModel
            randomDataModel.append({ text: text, icon: icon });
        }
    }
    Row{
        leftPadding: 5
        spacing: 3
        GaIconButton{
            iconSource: Icons.Bluetooth
        }
        GaIconButton{
            iconSource: Icons.More
        }
        GaIconButton{
            display: Button.TextBesideIcon
            iconSource: Icons.Video
            text: "深色模式"
            onClicked: {
                Theme.themeType=Theme.ModeType.Dark
            }
        }
        GaIconButton{
            display: Button.TextBesideIcon
            iconSource: Icons.Zoom
            text: "浅色模式"
            onClicked: {
                Theme.themeType=Theme.ModeType.Light
            }
        }
        GaComboBox{
            id:mboBox
            model: randomDataModel
        }
        GaIconButton{
            display: Button.TextBesideIcon
            iconSource: Icons.ZoomOut
            text: "添加ComboBox数据"
            onClicked: {
                mboBox.clearAll()
                randomDataModel.clear()
                generateRandomData()
            }
        }
    }

}
