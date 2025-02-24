package com.robot.app.worldMap
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.ServerConfig;
   import com.robot.core.config.UpdateConfig;
   import com.robot.core.config.xml.GalaxyXMLInfo;
   import com.robot.core.config.xml.SuperMapXMLInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.MapHotInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.mapTip.MapTip;
   import com.robot.core.ui.mapTip.MapTipInfo;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Cubic;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class WorldMapPanel extends Sprite
   {
      private const GALAXY_NAME:String = "galaxy";
      
      private var hotMCArray:Array = [];
      
      private var mapMC:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var perHot:uint = 10;
      
      private var myIcon:MovieClip;
      
      private var txt:TextField;
      
      private var galaxyMC:MovieClip;
      
      private var galaxyArray:Array = [];
      
      private var backBtn:SimpleButton;
      
      private var infoTxt:TextField;
      
      private var intervalId:uint;
      
      private var subPanel:AppModel;
      
      public function WorldMapPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            loader = new MCLoader("resource/worldMap.swf",LevelManager.appLevel,1,"正在打开星系地图");
            loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            loader.addEventListener(MCLoadEvent.CLOSE,this.onCloseLoad);
            loader.doLoad();
         }
         else
         {
            setTimeout(this.initMap,200);
         }
      }
      
      private function onCloseLoad(event:MCLoadEvent) : void
      {
         this.close();
      }
      
      private function onLoad(event:MCLoadEvent) : void
      {
         var shape:Shape = null;
         this.app = event.getApplicationDomain();
         this.mapMC = event.getContent() as MovieClip;
         setTimeout(this.initMap,200);
         shape = new Shape();
         shape.graphics.beginFill(0);
         shape.graphics.drawRect(0,0,320,30);
         shape.graphics.endFill();
         shape.x = 508;
         shape.y = 398;
         this.mapMC.addChild(shape);
         this.txt = new TextField();
         this.mapMC.addChild(this.txt);
         this.txt.height = 30;
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.txt.cacheAsBitmap = true;
         this.txt.x = shape.x;
         this.txt.y = shape.y;
         this.txt.mask = shape;
         this.txt.text = UpdateConfig.mapScrollArray.join("        ");
         var tf:TextFormat = new TextFormat();
         tf.size = 14;
         tf.color = 16777215;
         this.txt.setTextFormat(tf);
         this.txt.addEventListener(Event.ENTER_FRAME,this.onTxtEnterFrame);
      }
      
      private function onTxtEnterFrame(event:Event) : void
      {
         this.txt.x -= 1;
         if(this.txt.x < -(this.txt.textWidth + 20))
         {
            this.txt.x = 508 + 322;
         }
      }
      
      private function initMap() : void
      {
         var btn:SimpleButton = null;
         var str:String = null;
         var id:uint = 0;
         addChild(this.mapMC);
         this.backBtn = this.mapMC["backBtn"];
         if(!this.subPanel)
         {
            this.backBtn.visible = false;
         }
         else
         {
            this.subPanel.content["getHot"]();
         }
         this.backBtn.addEventListener(MouseEvent.CLICK,this.backHandler);
         var clostBtn:SimpleButton = this.mapMC["closeBtn"];
         clostBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.initGalaxy();
         var mc:MovieClip = this.mapMC["shipBtnMC"];
         var num:uint = uint(mc.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            btn = mc.getChildAt(i) as SimpleButton;
            if(Boolean(btn))
            {
               btn.addEventListener(MouseEvent.CLICK,this.changeMap);
               id = uint(btn.name.split("_")[1]);
               str = MapConfig.getName(id) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(id) + "</font>";
               btn.addEventListener(MouseEvent.MOUSE_OVER,this.onMosOver);
               btn.addEventListener(MouseEvent.MOUSE_OUT,this.onMosOut);
            }
         }
         SocketConnection.addCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         SocketConnection.mainSocket.send(CommandID.MAP_HOT,[]);
         var serverID:uint = uint(MainManager.serverID);
         this.mapMC["serverNameTxt"].text = serverID.toString() + ". " + ServerConfig.getNameByID(serverID);
         if(TasksManager.getTaskStatus(45) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 1;
         }
         else
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 0;
         }
         this.initMyPostion();
      }
      
      private function backHandler(event:MouseEvent) : void
      {
         this.backBtn.visible = false;
         if(Boolean(this.subPanel))
         {
            this.subPanel.destroy();
            this.subPanel = null;
         }
         this.galaxyMC.mouseChildren = true;
         TweenLite.to(this.galaxyMC,1,{
            "alpha":1,
            "x":94,
            "y":95
         });
      }
      
      private function onMosOver(evt:MouseEvent) : void
      {
         var id:uint = 0;
         var btn:SimpleButton = evt.currentTarget as SimpleButton;
         id = uint(btn.name.split("_")[1]);
         this.intervalId = setTimeout(function():void
         {
            MapTip.show(new MapTipInfo(id));
         },500);
      }
      
      private function onMosOut(evt:MouseEvent) : void
      {
         clearInterval(this.intervalId);
         MapTip.hide();
      }
      
      private function onGetMapHot(event:SocketEvent) : void
      {
         var i:uint = 0;
         var shipBtnMC:MovieClip = null;
         var btn:SimpleButton = null;
         var num:uint = 0;
         var cls:* = undefined;
         var mc:MovieClip = null;
         var hotMC:MovieClip = null;
         var hot:uint = 0;
         var j:uint = 0;
         SocketConnection.removeCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         var data:MapHotInfo = event.data as MapHotInfo;
         for each(i in data.infos.getKeys())
         {
            shipBtnMC = this.mapMC["shipBtnMC"];
            btn = shipBtnMC.getChildByName("btn_" + i) as SimpleButton;
            if(Boolean(btn) && i != 102)
            {
               num = Math.ceil(uint(data.infos.getValue(i)) / this.perHot);
               if(num > 5)
               {
                  num = 5;
               }
               for(i = 0; i < num; i++)
               {
                  cls = this.app.getDefinition("ShipHotMC");
                  mc = new cls() as MovieClip;
                  mc.filters = [new DropShadowFilter(2,45,0,1,3,3)];
                  mc.mouseEnabled = false;
                  mc.x = btn.x + 4;
                  mc.y = btn.y + btn.height - 8 - mc.height * i;
                  shipBtnMC.addChild(mc);
                  this.hotMCArray.push(mc);
               }
            }
            if(i == 102)
            {
               if(Boolean(btn))
               {
                  hotMC = shipBtnMC.getChildByName("hotMC_" + i) as MovieClip;
                  hot = Math.ceil(uint(data.infos.getValue(i)) / this.perHot);
                  if(hot > 5)
                  {
                     hot = 5;
                  }
                  for(j = 0; j < 5; j++)
                  {
                     if(j < hot)
                     {
                        hotMC["mc_" + j].gotoAndStop(1);
                     }
                     else
                     {
                        hotMC["mc_" + j].gotoAndStop(2);
                     }
                  }
               }
            }
         }
      }
      
      private function changeMap(e:MouseEvent) : void
      {
         var name:String = (e.currentTarget as SimpleButton).name;
         var id:uint = uint(name.split("_")[1]);
         MapManager.changeMap(id);
         this.close();
      }
      
      private function close(event:MouseEvent = null) : void
      {
         var i:MovieClip = null;
         this.galaxyArray = [];
         DisplayUtil.removeForParent(this,false);
         for each(i in this.hotMCArray)
         {
            DisplayUtil.removeForParent(i);
         }
         this.hotMCArray = [];
      }
      
      private function initGalaxy() : void
      {
         var o:InteractiveObject = null;
         var id:uint = 0;
         this.galaxyMC = this.mapMC["galaxyMC"];
         var num:uint = uint(this.galaxyMC.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            o = this.galaxyMC.getChildAt(i) as InteractiveObject;
            if(Boolean(o))
            {
               if(o.name.substring(0,6) == this.GALAXY_NAME)
               {
                  id = uint(o.name.split("_")[1]);
                  this.galaxyArray.push(o);
                  o.cacheAsBitmap = true;
                  o.filters = [ColorFilter.setBrightness(-20)];
                  o.addEventListener(MouseEvent.ROLL_OVER,this.onOverGalaxy);
                  o.addEventListener(MouseEvent.ROLL_OUT,this.onOutGalaxy);
                  o.addEventListener(MouseEvent.CLICK,this.onClickGalaxy);
                  ToolTipManager.add(o,GalaxyXMLInfo.getName(id));
               }
            }
         }
         if(Boolean(this.subPanel))
         {
            this.subPanel.show();
         }
      }
      
      private function onOverGalaxy(event:MouseEvent) : void
      {
         var mc:InteractiveObject = event.target as InteractiveObject;
         mc.filters = [ColorFilter.setBrightness(30)];
      }
      
      private function onOutGalaxy(event:MouseEvent) : void
      {
         var mc:InteractiveObject = event.target as InteractiveObject;
         mc.filters = [ColorFilter.setBrightness(-20)];
      }
      
      private function onClickGalaxy(event:MouseEvent) : void
      {
         var mc:InteractiveObject = null;
         var i:InteractiveObject = null;
         var p:Point = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         this.galaxyMC.mouseChildren = false;
         this.backBtn.visible = true;
         mc = event.target as InteractiveObject;
         for each(i in this.galaxyArray)
         {
            i.mouseEnabled = true;
         }
         p = mc.localToGlobal(new Point());
         dx = 498 - p.x;
         dy = 269 - p.y;
         TweenLite.to(this.galaxyMC,1,{
            "x":this.galaxyMC.x + dx,
            "y":this.galaxyMC.y + dy,
            "ease":Cubic.easeOut,
            "onComplete":function():void
            {
               loadGalaxy(uint(mc.name.split("_")[1]));
               TweenLite.to(galaxyMC,1,{"alpha":0.2});
            }
         });
      }
      
      private function loadGalaxy(id:uint) : void
      {
         this.subPanel = new AppModel(ClientConfig.getAppModule("subMap/Galaxy_" + id),"正在进入" + GalaxyXMLInfo.getName(id));
         this.subPanel.init(this.mapMC);
         this.subPanel.setup();
         this.subPanel.show();
      }
      
      private function initMyPostion() : void
      {
         var cls:* = undefined;
         var btn:SimpleButton = null;
         if(!this.myIcon)
         {
            cls = this.app.getDefinition("my_icon");
            this.myIcon = new cls() as MovieClip;
            this.myIcon.mouseChildren = false;
            this.myIcon.mouseEnabled = false;
            DisplayUtil.FillColor(this.myIcon["mc"]["colorMC"],MainManager.actorInfo.color);
         }
         var p:Point = SuperMapXMLInfo.getWorldMapPos(MapConfig.getSuperMapID(MainManager.actorInfo.mapID));
         if(Boolean(p))
         {
            if(p.x == 0 && p.y == 0)
            {
               btn = this.mapMC["shipBtnMC"].getChildByName("btn_" + MainManager.actorInfo.mapID) as SimpleButton;
               if(Boolean(btn))
               {
                  this.myIcon.x = btn.x;
                  this.myIcon.y = btn.y;
                  this.mapMC["shipBtnMC"].addChild(this.myIcon);
               }
               else
               {
                  DisplayUtil.removeForParent(this.myIcon,false);
               }
            }
            else
            {
               DisplayUtil.removeForParent(this.myIcon,false);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this.myIcon,false);
         }
      }
   }
}

