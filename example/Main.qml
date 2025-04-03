import QtQuick
import "../Controls"
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello ccc")
    property int name: 10000
    Row{
        padding: 5
        spacing: 6
        QIcon{
            icosource: FluentIcons.q_VPN
        }
        QComboBox{
            id:bobox
            model: generateRandomData()
        }


    }
    // 随机数据生成函数
    function generateRandomData() {
        const countries = ["中国", "美国", "日本", "德国", "法国", "英国", "意大利", "加拿大", "澳大利亚", "巴西",
                         "俄罗斯", "印度", "韩国", "西班牙", "墨西哥", "阿根廷", "南非", "埃及", "瑞典", "挪威"];

        const animals = ["狮子", "老虎", "大象", "长颈鹿", "熊猫", "斑马", "犀牛", "河马", "猎豹", "袋鼠",
                        "考拉", "企鹅", "海豚", "鲸鱼", "鲨鱼", "老鹰", "孔雀", "鹦鹉", "变色龙", "蟒蛇"];

        const phrases = ["早上好", "今天天气真好", "你吃饭了吗", "周末愉快", "新年快乐",
                        "工作顺利", "学习进步", "身体健康", "万事如意", "心想事成",
                        "恭喜发财", "步步高升", "一帆风顺", "出入平安", "阖家欢乐"];

        const items = ["笔记本电脑", "智能手机", "电视机", "电冰箱", "洗衣机",
                      "空调", "微波炉", "咖啡机", "电动牙刷", "吹风机",
                      "台灯", "书架", "沙发", "餐桌", "衣柜"];

        const plants = ["玫瑰花", "向日葵", "仙人掌", "郁金香", "百合花",
                       "康乃馨", "茉莉花", "牡丹", "菊花", "梅花",
                       "橡树", "松树", "柳树", "银杏", "竹子"];

        let data = [];
        const categories = [countries, animals, phrases, items, plants];

        // 生成1万条随机数据
        for (let i = 0; i < name; i++) {
            // 随机选择一个类别
            const category = categories[Math.floor(Math.random() * categories.length)];
            // 随机选择该类别的条目
            let item = category[Math.floor(Math.random() * category.length)];

            // 确保文本长度大于5个字符（中文每个字符算1个长度）
            // 如果不够长，添加随机后缀
            if (item.length <= 5) {
                const suffixes = ["特别版", "高级版", "限量版", "豪华版", "专业版", "经典款", "2023款"];
                item += suffixes[Math.floor(Math.random() * suffixes.length)];
            }

            // 添加序号前缀
            data.push(`${i+1}. ${item}`);
        }

        return data;
    }

}
