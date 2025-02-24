package com.robot.app.ogre.boss
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.BossModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class FungusBoss extends BossModel
   {
      private var _film:MovieClip;
      
      private var _isNo:Boolean = false;
      
      public function FungusBoss(id:uint, region:uint)
      {
         scaleY = 2;
         scaleX = 2;
         super(id,region);
      }
      
      override public function set hp(v:uint) : void
      {
         super.hp = v;
         if(_hp <= 0)
         {
            this._isNo = true;
            if(Boolean(this._film))
            {
               this._film.addFrameScript(this._film.totalFrames - 1,this.onEnter);
               this._film.gotoAndPlay("s_3");
               EventManager.dispatchEvent(new Event("FungusBoss_Film_No"));
            }
         }
      }
      
      override public function show(p:Point, h:uint) : void
      {
         super.show(p,h);
         this.hp = h;
         if(Boolean(this._film))
         {
            return;
         }
         if(h <= 0)
         {
            return;
         }
         ResourceManager.getResource(ClientConfig.getResPath("eff/film.swf"),this.onLoad);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this._film))
         {
            this._film.addFrameScript(this._film.totalFrames - 1,null);
            DisplayUtil.removeForParent(this._film);
            this._film = null;
         }
      }
      
      override public function aimatState(info:AimatInfo) : void
      {
         if(info.id != 10001)
         {
            return;
         }
         super.aimatState(info);
         if(Boolean(this._film))
         {
            if(this._film.currentLabel != "s_2")
            {
               this._film.gotoAndPlay("s_2");
            }
         }
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this._film = o as MovieClip;
         this._film.scaleY = 0.5;
         this._film.scaleX = 0.5;
         this._film.y = -10;
         this._film.gotoAndStop("s_1");
         addChild(this._film);
      }
      
      private function onEnter() : void
      {
         this._film.addFrameScript(this._film.totalFrames - 1,null);
         DisplayUtil.removeForParent(this._film);
         this._film = null;
      }
   }
}

