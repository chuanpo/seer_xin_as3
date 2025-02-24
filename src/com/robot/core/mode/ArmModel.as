package com.robot.core.mode
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.FortressItemXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.teamInstallation.TeamInfoController;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.SolidDir;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ArmModel extends SpriteModel
   {
      public var funID:uint;
      
      private var _info:ArmInfo;
      
      protected var _dragEnabled:Boolean;
      
      private var _unit:IFunUnit;
      
      private var _content:Sprite;
      
      private var _resURL:String = "";
      
      private var _markMc:MovieClip;
      
      public function ArmModel()
      {
         super();
      }
      
      public function get info() : ArmInfo
      {
         return this._info;
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(b:Boolean) : void
      {
         this._dragEnabled = b;
         if(this._dragEnabled)
         {
            addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            removeEventListener(MouseEvent.CLICK,this.onPanelClick);
         }
         else
         {
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            if(!this.funID)
            {
               addEventListener(MouseEvent.CLICK,this.onPanelClick);
            }
         }
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function show(i:ArmInfo, doc:DisplayObjectContainer) : void
      {
         if(this._resURL != "")
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this._info = i;
         if(this._info.form == 0)
         {
            this._resURL = this._info.styleID.toString();
         }
         else
         {
            buttonMode = true;
            if(this._info.form == 1)
            {
               if(this._info.resNum == 0)
               {
                  this._resURL = this._info.styleID.toString() + "_" + this._info.form.toString();
               }
               else
               {
                  this._resURL = this._info.styleID.toString() + "_b";
               }
            }
            else
            {
               this._resURL = this._info.styleID.toString() + "_" + this._info.form.toString();
            }
         }
         doc.addChild(this);
         x = this._info.pos.x;
         y = this._info.pos.y;
         direction = Direction.indexToStr(this._info.dir);
         this.changeUI(this._resURL);
      }
      
      public function checkIsUp() : Boolean
      {
         var num:uint = 0;
         var ownA:Array = null;
         var needA:Array = null;
         var allOwn:uint = 0;
         var allNeed:uint = 0;
         var i1:int = 0;
         var b1:Boolean = true;
         if(this._info.form >= uint(FortressItemXMLInfo.getMaxLevel(this._info.id)))
         {
            return false;
         }
         if(this._info.id == 3 && this._info.form == 2)
         {
            return false;
         }
         if(this._info.isUsed)
         {
            if(this._info.form == 1)
            {
               num = uint(this._info.res.getValues()[0]);
               if(num < 5000)
               {
                  b1 = false;
               }
            }
            else
            {
               ownA = this._info.res.getValues();
               needA = FortressItemXMLInfo.getResMaxs(this._info.id,this._info.form);
               for(i1 = 0; i1 < 4; i1++)
               {
                  allOwn += ownA[i1];
                  allNeed += needA[i1];
               }
               if(allOwn < allNeed)
               {
                  b1 = false;
               }
            }
         }
         else
         {
            b1 = false;
         }
         return b1;
      }
      
      public function showUpMark() : void
      {
         var rec:Rectangle = null;
         if(MapManager.currentMap.id == MainManager.actorInfo.teamInfo.id)
         {
            this._markMc = TaskIconManager.getIcon("EquipUpMarkMc") as MovieClip;
            this._markMc.scaleY = 0.6;
            this._markMc.scaleX = 0.6;
            this._markMc.gotoAndPlay(1);
            rec = this.getRect(this._content);
            this._markMc.y = rec.y - this._markMc.height;
            this._markMc.x = -this._markMc.width / 2;
            addChild(this._markMc);
         }
      }
      
      public function hideUpMark() : void
      {
         if(Boolean(this._markMc))
         {
            if(DisplayUtil.hasParent(this._markMc))
            {
               this.removeChild(this._markMc);
               this._markMc = null;
            }
         }
      }
      
      public function hide() : void
      {
         this.dragEnabled = false;
         DisplayUtil.removeForParent(this);
      }
      
      override public function destroy() : void
      {
         this.hide();
         super.destroy();
         if(this._resURL != "")
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         if(Boolean(this.funID))
         {
            ResourceManager.cancel(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit);
         }
         if(Boolean(this._unit))
         {
            this._unit.destroy();
            this._unit = null;
         }
         if(Boolean(this._content))
         {
            this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
            this._content = null;
         }
         TeamInfoController.destroy();
         this._info = null;
      }
      
      public function setSelect(b:Boolean) : void
      {
         if(b)
         {
            filters = [new GlowFilter(16711680)];
         }
         else
         {
            filters = [];
         }
      }
      
      public function setBufForInfo(info:ArmInfo) : void
      {
         this._info.pos = info.pos;
         this._info.dir = info.dir;
         this._info.status = info.status;
         x = this._info.pos.x;
         y = this._info.pos.y;
         direction = Direction.indexToStr(this._info.dir);
         this.changeDir();
      }
      
      public function setFormUpDate(form:uint) : void
      {
         if(this._info.form >= form)
         {
            return;
         }
         this._info.form = form;
         if(Boolean(this._resURL))
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this.changeUI(this._info.styleID.toString() + "_" + this._info.form.toString());
      }
      
      public function setWork(workCount:uint, totalRes:uint) : void
      {
         if(this._info.form != 1)
         {
            return;
         }
         if(this._info.resNum != 0)
         {
            return;
         }
         this._info.workCount = workCount;
         this._info.resNum = totalRes;
         if(Boolean(this._resURL))
         {
            ResourceManager.cancel(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
         }
         this.changeUI(this._info.styleID.toString() + "_b");
      }
      
      public function changeUI(str:String) : void
      {
         if(Boolean(this._unit))
         {
            this._unit.destroy();
            this._unit = null;
         }
         if(Boolean(this._content))
         {
            this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
            DisplayUtil.removeForParent(this._content);
            this._content = null;
         }
         this._resURL = str;
         ResourceManager.getResource(ClientConfig.getArmItem(this._resURL),this.onLoadRes);
      }
      
      private function changeDir() : void
      {
         if(this._content is MovieClip)
         {
            if(MovieClip(this._content).totalFrames == 1)
            {
               if(this._info.dir == SolidDir.DIR_LEFT)
               {
                  this._content.scaleX = 1;
               }
               else if(this._info.dir == SolidDir.DIR_RIGHT)
               {
                  this._content.scaleX = -1;
               }
            }
            else if(this._info.dir == SolidDir.DIR_LEFT)
            {
               MovieClip(this._content).gotoAndStop(1);
            }
            else if(this._info.dir == SolidDir.DIR_RIGHT)
            {
               MovieClip(this._content).gotoAndStop(2);
            }
            else if(this._info.dir == SolidDir.DIR_BUTTOM)
            {
               MovieClip(this._content).gotoAndStop(3);
            }
            else if(this._info.dir == SolidDir.DIR_TOP)
            {
               MovieClip(this._content).gotoAndStop(4);
            }
         }
         else if(this._info.dir == SolidDir.DIR_LEFT)
         {
            this._content.scaleX = 1;
         }
         else if(this._info.dir == SolidDir.DIR_RIGHT)
         {
            this._content.scaleX = -1;
         }
      }
      
      private function onLoadRes(o:DisplayObject) : void
      {
         var isComFun:Boolean = false;
         this._content = o as Sprite;
         this._content.addEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
         addChild(this._content);
         if(this.checkIsUp())
         {
            this.showUpMark();
         }
         if(this._info.buyTime == 0)
         {
            this.funID = ItemXMLInfo.getFunID(this._info.id);
         }
         else
         {
            this.funID = FortressItemXMLInfo.getFunID(this._info.id);
         }
         if(this.funID != 0)
         {
            if(this._info.buyTime == 0)
            {
               isComFun = ItemXMLInfo.getFunIsCom(this._info.id);
            }
            else
            {
               isComFun = FortressItemXMLInfo.getFunIsCom(this._info.id);
            }
            if(isComFun)
            {
               this._content.buttonMode = true;
               ResourceManager.getResource(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit,"");
            }
            else if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.mapID)
            {
               this._content.buttonMode = true;
               ResourceManager.getResource(ClientConfig.getAppExtSwf(this.funID.toString()),this.onLoadUnit,"");
            }
            else
            {
               this._content.mouseEnabled = false;
               this._content.mouseChildren = false;
            }
         }
         else
         {
            this._content.mouseEnabled = false;
         }
         this.changeDir();
         if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.mapID)
         {
            if(!this.funID)
            {
               addEventListener(MouseEvent.CLICK,this.onPanelClick);
            }
         }
         else
         {
            mouseEnabled = false;
            buttonMode = false;
         }
      }
      
      private function onLoadUnit(o:DisplayObject) : void
      {
         this._unit = o as IFunUnit;
         this._unit.setup(this._content);
         this._unit.init(this._info);
      }
      
      private function onADDStage(e:Event) : void
      {
         this._content.removeEventListener(Event.ADDED_TO_STAGE,this.onADDStage);
         DepthManager.swapDepth(this,y);
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         var dir:uint = 0;
         if(Boolean(this._content))
         {
            if(e.keyCode == Keyboard.LEFT)
            {
               dir = SolidDir.DIR_LEFT;
            }
            else if(e.keyCode == Keyboard.RIGHT)
            {
               dir = SolidDir.DIR_RIGHT;
            }
            else if(e.keyCode == Keyboard.DOWN)
            {
               if(this._content is MovieClip)
               {
                  if(MovieClip(this._content).totalFrames >= 3)
                  {
                     dir = SolidDir.DIR_BUTTOM;
                  }
               }
            }
            else if(e.keyCode == Keyboard.UP)
            {
               if(this._content is MovieClip)
               {
                  if(MovieClip(this._content).totalFrames >= 4)
                  {
                     dir = SolidDir.DIR_TOP;
                  }
               }
            }
            if(dir != this._info.dir)
            {
               this._info.dir = dir;
               this.changeDir();
               ArmManager.setIsChange(this._info);
            }
         }
      }
      
      private function onPanelClick(e:MouseEvent) : void
      {
         TeamInfoController.start(this._info);
      }
   }
}

