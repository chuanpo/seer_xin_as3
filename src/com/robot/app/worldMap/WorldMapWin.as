package com.robot.app.worldMap
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ServerConfig;
   import com.robot.core.config.UpdateConfig;
   import com.robot.core.config.xml.SuperMapXMLInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.MapHotInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class WorldMapWin extends Sprite
   {
      private var mapMC:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var hotMCArray:Array = [];
      
      private var perHot:uint = 10;
      
      private var txt:TextField;
      
      private var shape:Shape;
      
      private var prevBtn:SimpleButton;
      
      private var nextBtn:SimpleButton;
      
      private var dir:int;
      
      private var myIcon:MovieClip;
      
      private var mapScrollRect:Rectangle;
      
      private var bgScrollRect:Rectangle;
      
      private var target:Number = 0;
      
      private var target2:Number = 0;
      
      private var isHited:Boolean = false;
      
      public function WorldMapWin()
      {
         super();
         this.mapScrollRect = new Rectangle(0,0,763,260);
         this.mapScrollRect.x = 124 + 696;
         this.bgScrollRect = new Rectangle(0,0,783,356);
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            loader = new MCLoader("resource/worldMap.swf",LevelManager.appLevel,1,"正在打开星际地图");
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
         this.app = event.getApplicationDomain();
         this.mapMC = event.getContent() as MovieClip;
         setTimeout(this.initMap,200);
         this.shape = new Shape();
         this.shape.graphics.beginFill(0);
         this.shape.graphics.drawRect(0,0,322,30);
         this.shape.graphics.endFill();
         this.shape.x = 508;
         this.shape.y = 398;
         this.mapMC.addChild(this.shape);
         this.txt = new TextField();
         this.mapMC.addChild(this.txt);
         this.txt.height = 30;
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.txt.cacheAsBitmap = true;
         this.txt.x = this.shape.x;
         this.txt.y = this.shape.y;
         this.txt.mask = this.shape;
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
         var id:uint = 0;
         var str:String = null;
         addChild(this.mapMC);
         if(TasksManager.getTaskStatus(47) == TasksManager.COMPLETE)
         {
            this.mapMC["plantBtnMC"]["stones_mc"].visible = false;
         }
         if(TasksManager.getTaskStatus(19) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["plantBtnMC"]["task_19"].alpha = 1;
         }
         else
         {
            this.mapMC["plantBtnMC"]["task_19"].alpha = 0;
         }
         if(TasksManager.getTaskStatus(45) == TasksManager.ALR_ACCEPT)
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 1;
         }
         else
         {
            this.mapMC["shipBtnMC"]["taskIcon_45"].alpha = 0;
         }
         var clostBtn:SimpleButton = this.mapMC["closeBtn"];
         clostBtn.addEventListener(MouseEvent.CLICK,this.close);
         MovieClip(this.mapMC["plantBtnMC"]).scrollRect = this.mapScrollRect;
         this.mapMC.addEventListener(Event.ENTER_FRAME,this.onMapEnter);
         var serverID:uint = uint(MainManager.serverID);
         this.mapMC["serverNameTxt"].text = serverID.toString() + ". " + ServerConfig.getNameByID(serverID);
         var mc:MovieClip = this.mapMC["plantBtnMC"];
         var num:uint = uint(mc.numChildren);
         for(var i:int = 0; i < num; i++)
         {
            btn = mc.getChildAt(i) as SimpleButton;
            if(Boolean(btn))
            {
               btn.addEventListener(MouseEvent.CLICK,this.changeMap);
               id = uint(btn.name.split("_")[1]);
               str = MapConfig.getName(id) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(id) + "</font>";
               ToolTipManager.add(btn,str);
            }
         }
         mc = this.mapMC["shipBtnMC"];
         num = uint(mc.numChildren);
         for(i = 0; i < num; i++)
         {
            btn = mc.getChildAt(i) as SimpleButton;
            if(Boolean(btn))
            {
               btn.addEventListener(MouseEvent.CLICK,this.changeMap);
               id = uint(btn.name.split("_")[1]);
               str = MapConfig.getName(id) + "\r<font color=\'#ff0000\'>" + MapConfig.getDes(id) + "</font>";
               ToolTipManager.add(btn,str);
            }
         }
         SocketConnection.addCmdListener(CommandID.MAP_HOT,this.onGetMapHot);
         SocketConnection.mainSocket.send(CommandID.MAP_HOT,[]);
         this.initMyPostion();
      }
      
      private function changeMap(e:MouseEvent) : void
      {
         var name:String = (e.currentTarget as SimpleButton).name;
         var id:uint = uint(name.split("_")[1]);
         MapManager.changeMap(id);
         this.close();
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
         this.showPlantHot(data);
      }
      
      private function showPlantHot(data:MapHotInfo) : void
      {
         var btn:SimpleButton = null;
         var id:uint = 0;
         var hotMC:MovieClip = null;
         var hot:uint = 0;
         var j:uint = 0;
         var mc:MovieClip = this.mapMC["plantBtnMC"];
         var num:uint = uint(mc.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            btn = mc.getChildAt(i) as SimpleButton;
            if(Boolean(btn))
            {
               id = uint(btn.name.split("_")[1]);
               hotMC = mc.getChildByName("hotMC_" + id) as MovieClip;
               hot = Math.ceil(uint(data.infos.getValue(id)) / this.perHot);
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
      
      private function close(event:MouseEvent = null) : void
      {
         var i:MovieClip = null;
         this.isHited = false;
         DisplayUtil.removeForParent(this,false);
         for each(i in this.hotMCArray)
         {
            DisplayUtil.removeForParent(i);
         }
         this.hotMCArray = [];
         if(Boolean(this.prevBtn))
         {
            this.prevBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.prevBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.nextBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         }
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onDown(event:MouseEvent) : void
      {
         var btn:SimpleButton = event.currentTarget as SimpleButton;
         if(btn == this.prevBtn)
         {
            this.dir = 1;
         }
         else
         {
            this.dir = -1;
         }
         var mc:MovieClip = this.mapMC["plantBtnMC"];
         mc.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(event:Event) : void
      {
         var mc:MovieClip = this.mapMC["plantBtnMC"];
         mc.x += 4 * this.dir;
         this.mapMC["spaceBg"].x += 1.2 * this.dir;
         if(mc.x < -182)
         {
            mc.x = -182;
            mc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         }
         if(mc.x > 136)
         {
            mc.x = 136;
            mc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         }
      }
      
      private function onUp(event:MouseEvent) : void
      {
         var mc:MovieClip = this.mapMC["plantBtnMC"];
         mc.removeEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onMapEnter(event:Event) : void
      {
         var dis:Number = 124 + 756;
         var mousex:Number = Number(MainManager.getStage().mouseX);
         var p:Number = (mousex - 124) / (825 - 124);
         if(!(!this.mapMC["plantBtnMC"].hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true) || mousex < 124 || mousex > 825))
         {
            if(!this.isHited && Boolean(this.mapMC["plantBtnMC"].hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true)))
            {
               this.isHited = true;
            }
            this.target = dis * p;
            this.target2 = dis * p / 3;
         }
         if(!this.isHited)
         {
            return;
         }
         if(Math.abs(this.target - this.mapScrollRect.x) < 2)
         {
            this.mapScrollRect.x = this.target;
         }
         else
         {
            this.mapScrollRect.x += (this.target - this.mapScrollRect.x) / 12;
         }
         MovieClip(this.mapMC["plantBtnMC"]).scrollRect = this.mapScrollRect;
         if(Math.abs(this.target2 - this.bgScrollRect.x) < 2)
         {
            this.bgScrollRect.x = this.target2;
         }
         else
         {
            this.bgScrollRect.x += (this.target2 - this.bgScrollRect.x) / 12;
         }
         MovieClip(this.mapMC["spaceBg"]).scrollRect = this.bgScrollRect;
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
               return;
            }
            this.myIcon.x = p.x;
            this.myIcon.y = p.y;
            this.mapMC["plantBtnMC"].addChild(this.myIcon);
         }
         else
         {
            DisplayUtil.removeForParent(this.myIcon,false);
         }
      }
   }
}

