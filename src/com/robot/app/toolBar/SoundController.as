package com.robot.app.toolBar
{
   import com.robot.core.SoundManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SoundController
   {
      private static var _musicPower_mc:MovieClip;
      
      public function SoundController()
      {
         super();
      }
      
      public static function controller(mc:DisplayObjectContainer, _x:Number, _y:Number) : void
      {
         _musicPower_mc = UIManager.getMovieClip("SoundController_mc");
         mc.addChild(_musicPower_mc);
         _musicPower_mc.x = _x;
         _musicPower_mc.y = _y;
         _musicPower_mc.addEventListener(MouseEvent.CLICK,onMusicMcClickHandler);
         ToolTipManager.add(_musicPower_mc,"关闭音乐");
      }
      
      private static function onMusicMcClickHandler(event:MouseEvent) : void
      {
         if(SoundManager.getIsPlay == true)
         {
            _musicPower_mc["mc2"].visible = false;
            _musicPower_mc["mc1"].visible = true;
            ToolTipManager.remove(_musicPower_mc);
            ToolTipManager.add(_musicPower_mc,"打开音乐");
            SoundManager.setIsPlay = false;
            SoundManager.stopSound();
         }
         else
         {
            _musicPower_mc["mc2"].visible = true;
            _musicPower_mc["mc1"].visible = false;
            ToolTipManager.remove(_musicPower_mc);
            ToolTipManager.add(_musicPower_mc,"关闭音乐");
            SoundManager.setIsPlay = true;
            SoundManager.playSound();
         }
      }
      
      public static function destroy() : void
      {
         _musicPower_mc.removeEventListener(MouseEvent.CLICK,onMusicMcClickHandler);
         ToolTipManager.remove(_musicPower_mc);
         DisplayUtil.removeForParent(_musicPower_mc);
         _musicPower_mc = null;
      }
   }
}

