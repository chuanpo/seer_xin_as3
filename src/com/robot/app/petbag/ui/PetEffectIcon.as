package com.robot.app.petbag.ui
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetEffectXMLInfo;
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class PetEffectIcon extends Sprite
   {
      private var _bgMc:Sprite;
      
      private var _itemId:uint;
      
      private var _path:String = "resource/item/petItem/effectIcon/";
      
      private var _iconMc:MovieClip;
      
      private var _info:PetEffectInfo;
      
      private var _tipMC:MovieClip;
      
      private var _txt:String;
      
      public function PetEffectIcon()
      {
         super();
         this._bgMc = new Sprite();
         this._bgMc.graphics.lineStyle(1,0,1);
         this._bgMc.graphics.beginFill(0,1);
         this._bgMc.graphics.drawRect(0,0,45.5,26);
         this._bgMc.graphics.endFill();
         this._bgMc.alpha = 0;
         this.addChild(this._bgMc);
         this._tipMC = UIManager.getMovieClip("ui_SkillTipPanel");
      }
      
      public function show(info:PetEffectInfo) : void
      {
         this._info = info;
         this._itemId = this._info.itemId;
         ResourceManager.getResource(this._path + this._itemId + ".swf",this.onLoadComHandler);
      }
      
      private function onLoadComHandler(mc:DisplayObject) : void
      {
         var nameStr:String = null;
         var remain:String = null;
         var des:String = null;
         if(Boolean(mc))
         {
            this._iconMc = mc as MovieClip;
            this.addChild(this._iconMc);
            this._iconMc["txt"].text = this._info.leftCount.toString();
            nameStr = ItemXMLInfo.getName(this._itemId);
            remain = "剩余使用次数:" + this._info.leftCount.toString();
            des = PetEffectXMLInfo.getDes(this._itemId);
            this._txt = "<font color=\'#ffff00\' size=\'15\'>" + nameStr + "</font>\r\r" + "<font color=\'#ff0000\'>" + remain + "</font>\r\r" + "<font color=\'#ffffff\'>" + des + "</font>";
            this._tipMC["info_txt"].htmlText = this._txt;
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         }
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         var mX:Number = this.mouseX;
         var mY:Number = this.mouseY;
         var p:Point = this.localToGlobal(new Point(mX,mY));
         LevelManager.appLevel.addChild(this._tipMC);
         this._tipMC.x = p.x + 15;
         this._tipMC.y = p.y + 15;
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      private function onOutHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this._tipMC);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      public function destroy() : void
      {
         this.clear();
         if(this._itemId != 0)
         {
            ResourceManager.cancelURL(this._path + this._itemId + ".swf");
         }
         this.removeChild(this._bgMc);
         this._bgMc = null;
         this._tipMC = null;
      }
      
      private function onMoveHandler(e:MouseEvent) : void
      {
         this._tipMC.x = LevelManager.stage.mouseX + 15;
         this._tipMC.y = LevelManager.stage.mouseY + 15;
      }
      
      public function clear() : void
      {
         if(Boolean(this._iconMc))
         {
            this.removeChild(this._iconMc);
            this._iconMc = null;
         }
         this._info = null;
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         if(Boolean(this._tipMC))
         {
            DisplayUtil.removeForParent(this._tipMC);
         }
      }
   }
}

