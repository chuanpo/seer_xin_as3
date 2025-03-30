package com.robot.core.manager
{
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.bean.BeanManager;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.TaomeeManager;
   import flash.net.URLLoader;
   import flash.events.IOErrorEvent;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.config.XmlConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import flash.net.URLRequest;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.config.xml.ShinyXMLInfo;
   import com.robot.core.config.xml.SkillXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.config.xml.ItemTipXMLInfo;
   import com.robot.core.config.xml.GoldProductXMLInfo;
   
   public class MainManager
   {
      public static var isClothHalfDay:Boolean;
      
      public static var isRoomHalfDay:Boolean;
      
      public static var iFortressHalfDay:Boolean;
      
      public static var isHQHalfDay:Boolean;
      
      private static var _isMember:Boolean;
      
      private static var _actorInfo:UserInfo;
      
      private static var _actorModel:ActorModel;
      
      private static var _uiLoader:MCLoader;
      
      public static var actorID:uint;
      
      public static var serverID:uint;
      
      public static const DfSpeed:Number = 4.6;
      
      private static const XML_PATH:String = "config/xmlList.xml";

      private static const UI_PATH:String = "resource/ui.swf";
      
      private static const ICON_PATH:String = "resource/taskIcon.swf";
      
      private static const AIMAT_PATH:String = "resource/aimat/aimatUI.swf";
      
      public static var CHANNEL:uint = 0;

      public function MainManager()
      {
         super();
      }
      
      public static function setup(data:Object) : void
      {
         _actorInfo = new UserInfo();
         UserInfo.setForLoginInfo(_actorInfo,data as IDataInput);
         SocketConnection.mainSocket.userID = _actorInfo.userID;
         loaderUILib();
         // loadXMLList();
         TaomeeManager.initFightSpeed();
      }
      
      public static function creatActor() : void
      {
         _actorModel = new ActorModel(_actorInfo);
         if(_actorInfo.actionType == 1)
         {
            _actorModel.walk = new FlyAction(_actorModel);
         }
         else
         {
            _actorModel.walk = new WalkAction();
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_ACTOR));
      }
      
      private static function loadXMLList() : void
      {
         var urlloader:URLLoader = new URLLoader();
         var xmlCompleteHandler:Function = null;
         var ioERRORHandler:Function = null;
         xmlCompleteHandler = function(event:Event):void
         {
            urlloader.removeEventListener(Event.COMPLETE,xmlCompleteHandler);
            urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
            var xmlData:XML = new XML(event.target.data);
            XmlConfig.setup(xmlData);
            // loaderUILib();
            MapConfig.setup(initShinyXML);
            // initBean();
         }
         ioERRORHandler = function(e:IOErrorEvent):void
         {
            urlloader.removeEventListener(Event.COMPLETE,xmlCompleteHandler);
            urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
            Alarm.show("xml加载出错！")
         }
         urlloader.addEventListener(Event.COMPLETE,xmlCompleteHandler);
         urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioERRORHandler);
         urlloader.load(new URLRequest(XML_PATH + "?" + Math.random()));
      }

      private static function initShinyXML():void
      {
         ShinyXMLInfo.setup(initPetXML);
      }

      private static function initPetXML():void
      {
         PetXMLInfo.setup(initSkillXML);
      }

      private static function initSkillXML():void
      {
         SkillXMLInfo.parseInfo(initItemXML);
      }

      private static function initItemXML():void
      {
         ItemXMLInfo.parseInfo(initGlodItemXML);
      }

      private static function initGlodItemXML():void
      {
         GoldProductXMLInfo.setup(initItemTipXml);
      }

      private static function initItemTipXml():void
      {
         ItemTipXMLInfo.setup(initBean)
      }

      private static function loaderUILib() : void
      {
         trace("Progress-1：开始加载UI资源",UI_PATH);
         _uiLoader = new MCLoader(UI_PATH,MainManager.getStage(),1,"正在加载星球");
         _uiLoader.setIsShowClose(false);
         _uiLoader.addEventListener(MCLoadEvent.SUCCESS,onLoadUI);
         _uiLoader.addEventListener(MCLoadEvent.ERROR,onFailLoadUI);
         _uiLoader.doLoad();
      }
      
      private static function onLoadUI(event:MCLoadEvent) : void
      {
         var loader:MCLoader;
         UIManager.setup(event.getLoader());
         loader = new MCLoader(ICON_PATH,MainManager.getStage(),1,"正在加载任务信息");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoadIcon);
         loader.addEventListener(MCLoadEvent.ERROR,function(event:MCLoadEvent):void
         {
            throw new Error("ICON加载出错");
         });
         loader.doLoad();
      }
      
      private static function onLoadIcon(event:MCLoadEvent) : void
      {
         var loader:MCLoader;
         TaskIconManager.setup(event.getLoader());
         loader = new MCLoader(AIMAT_PATH,MainManager.getStage(),1,"正在加载任务信息");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoadAimat);
         loader.addEventListener(MCLoadEvent.ERROR,function(event:MCLoadEvent):void
         {
            throw new Error("AIMAT加载出错");
         });
         loader.doLoad();
      }
      
      private static function onLoadAimat(e:MCLoadEvent) : void
      {
         AimatUIManager.setup(e.getLoader());
         loadXMLList();
         // initBean();
      }
      
      private static function initBean() : void
      {
         trace("Progress-2：创建主角，执行BEAN控制");
         creatActor();
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,onAllBeanComplete);
         BeanManager.start();
      }
      
      private static function onAllBeanComplete(e:Event) : void
      {
         trace("Progress-2：初始化地图管理");
         if(checkIsNovice())
         {
            if(!TasksManager.isComNoviceTask())
            {
               MapManager.changeLocalMap(515);
            }
            else
            {
               MapManager.changeMap(MainManager.actorInfo.mapID);
            }
         }
         else
         {
            MapManager.changeMap(MainManager.actorInfo.mapID);
         }
         NonoManager.getInfo();
      }
      
      public static function checkIsNovice() : Boolean
      {
         var regTime:Number = MainManager.actorInfo.regTime * 1000;
         var isNovice:Boolean = true;
         var data:Date = new Date(regTime);
         var year:String = data.getFullYear().toString();
         var month:String = (data.getMonth() + 1).toString();
         if(month.length == 1)
         {
            month = "0" + month;
         }
         var date:String = data.getDate().toString();
         if(date.length == 1)
         {
            date = "0" + date;
         }
         var hour:String = data.getHours().toString();
         if(hour.length == 1)
         {
            hour = "0" + hour;
         }
         var min:String = data.getMinutes().toString();
         if(min.length == 1)
         {
            min = "0" + min;
         }
         var nu:Number = Number(year + month + date + hour + min);
         if(nu < 201003112359)
         {
            isNovice = false;
         }
         return isNovice;
      }
      
      public static function get isMember() : Boolean
      {
         return _isMember;
      }
      
      public static function get actorInfo() : UserInfo
      {
         return _actorInfo;
      }
      
      public static function get actorClothStr() : String
      {
         var i:PeopleItemInfo = null;
         var array:Array = actorInfo.clothes;
         var arr:Array = [];
         for each(i in array)
         {
            arr.push(i.id);
         }
         return arr.sort().join(",");
      }
      
      public static function get actorModel() : ActorModel
      {
         return _actorModel;
      }
      
      public static function upDateForPeoleInfo(info:UserInfo) : void
      {
         _actorInfo.userID = info.userID;
         _actorInfo.nick = info.nick;
         _actorInfo.color = info.color;
         _actorInfo.texture = info.texture;
         _actorInfo.vip = info.vip;
         _actorInfo.action = info.action;
         _actorInfo.direction = info.direction;
         _actorInfo.spiritID = info.spiritID;
         _actorInfo.fightFlag = info.fightFlag;
         _actorInfo.teacherID = info.teacherID;
         _actorInfo.studentID = info.studentID;
         _actorInfo.nonoState = info.nonoState.slice();
         _actorInfo.nonoColor = info.nonoColor;
         _actorInfo.nonoNick = info.nonoNick;
         _actorInfo.superNono = info.superNono;
         _actorInfo.clothes = info.clothes.slice();
      }
      
      public static function getRoot() : Sprite
      {
         return LevelManager.root;
      }
      
      public static function getStage() : Stage
      {
         return LevelManager.stage;
      }
      
      public static function getStageWidth() : int
      {
         return TaomeeManager.stageWidth;
      }
      
      public static function getStageHeight() : int
      {
         return TaomeeManager.stageHeight;
      }
      
      public static function getStageCenterPoint() : Point
      {
         return new Point(TaomeeManager.stageWidth / 2,TaomeeManager.stageHeight / 2);
      }
      
      public static function getStageMousePoint() : Point
      {
         return new Point(getStage().mouseX,getStage().mouseY);
      }
      
      private static function onFailLoadUI(event:MCLoadEvent) : void
      {
         throw new Error("UI/Icon资源加载错误");
      }
   }
}

