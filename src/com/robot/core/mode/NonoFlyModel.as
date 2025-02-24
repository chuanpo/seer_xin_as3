package com.robot.core.mode
{
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.nono.NonoInfoPanelController;
   import com.robot.core.ui.nono.NonoShortcut;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class NonoFlyModel extends BobyModel implements INonoModel
   {
      private const _url:String = "resource/nono/nonoFlyingMachine1.swf";
      
      private var _people:ActionSpriteModel;
      
      private var _flyMachineMc:MovieClip;
      
      private var _info:NonoInfo;
      
      public function NonoFlyModel(info:NonoInfo, people:ActionSpriteModel = null)
      {
         super();
         this._info = info;
         this._people = people;
         if(Boolean(people))
         {
            this._people.sprite.addChildAt(this,0);
            ResourceManager.getResource(this._url,this.onLoadMachineComHandler);
         }
      }
      
      public function set people(people:ActionSpriteModel) : void
      {
         this._people = people;
      }
      
      public function get people() : ActionSpriteModel
      {
         return this._people;
      }
      
      public function get info() : NonoInfo
      {
         return this._info;
      }
      
      override public function set direction(dir:String) : void
      {
         if(Boolean(this._flyMachineMc))
         {
            this._flyMachineMc["dirMc"].gotoAndStop(dir);
            this._flyMachineMc["colorMc"].gotoAndStop(dir);
            this._flyMachineMc["fireMc"].gotoAndStop(dir);
         }
      }
      
      public function startPlay() : void
      {
         if(Boolean(this._flyMachineMc))
         {
            setTimeout(function():void
            {
               _flyMachineMc["dirMc"]["mc"].play();
               _flyMachineMc["colorMc"]["mc"].play();
               _flyMachineMc["bgMc"]["mc"].play();
               _flyMachineMc["fireMc"]["mc"].play();
               _flyMachineMc["fireMc"].visible = true;
            },200);
         }
      }
      
      public function stopPlay() : void
      {
         if(Boolean(this._flyMachineMc))
         {
            setTimeout(function():void
            {
               _flyMachineMc["dirMc"]["mc"].stop();
               _flyMachineMc["colorMc"]["mc"].stop();
               _flyMachineMc["bgMc"]["mc"].stop();
               _flyMachineMc["fireMc"]["mc"].stop();
               _flyMachineMc["fireMc"].visible = false;
            },200);
         }
      }
      
      override public function get centerPoint() : Point
      {
         return new Point();
      }
      
      override public function get hitRect() : Rectangle
      {
         return new Rectangle(0,0,0,0);
      }
      
      override public function set visible(b1:Boolean) : void
      {
      }
      
      private function onLoadMachineComHandler(mc:DisplayObject) : void
      {
         if(Boolean(mc))
         {
            this._flyMachineMc = mc as MovieClip;
            addChild(this._flyMachineMc);
            this.direction = this._people.direction;
            this.stopPlay();
            this.buttonMode = true;
            if(this._info.userID == MainManager.actorID)
            {
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
            }
            this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
            DisplayUtil.FillColor(this._flyMachineMc["colorMc"],this._info.color);
         }
      }
      
      private function onClickHandler(e:MouseEvent) : void
      {
         NonoInfoPanelController.show(this._info);
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         if(this._people.walk.isPlaying)
         {
            return;
         }
         var p:Point = localToGlobal(new Point(0,0));
         NonoShortcut.show(p,this._info,true);
      }
      
      override public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         if(Boolean(this._flyMachineMc))
         {
            DisplayUtil.removeForParent(this._flyMachineMc);
            this._flyMachineMc = null;
         }
         this._info = null;
         this._people = null;
      }
   }
}

