package com.robot.core.ui.skillBtn
{
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   
   public class BlackSkillBtn extends NormalSkillBtn
   {
      public function BlackSkillBtn(_skillID:uint = 0, currentPP:int = -1)
      {
         super(_skillID,currentPP);
      }
      
      override protected function getMC() : MovieClip
      {
         return UIManager.getMovieClip("ui_PetUpdate_PetSkillBtn");
      }
   }
}

