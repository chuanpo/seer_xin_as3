package com.robot.core.manager
{
   import com.robot.core.effect.shotBehavior.EmptyBehavior;
   import com.robot.core.effect.shotBehavior.IShotBehavior;
   import com.robot.core.effect.shotBehavior.LaserBehavior;
   import com.robot.core.effect.shotBehavior.LightBehavior;
   import com.robot.core.effect.shotBehavior.MissileBehavior;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_2;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_3;
   import com.robot.core.effect.shotBehavior.ShotEffect_143_4;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_2;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_3;
   import com.robot.core.effect.shotBehavior.ShotEffect_144_4;
   import com.robot.core.effect.shotBehavior.ShotEffect_1_4;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class ShotBehaviorManager
   {
      private static var _loader:Loader;
      
      private static var hashMap:HashMap = new HashMap();
      
      public function ShotBehaviorManager()
      {
         super();
      }
      
      public static function setup(loader:Loader) : void
      {
         _loader = loader;
         addBehavior(1,2,LightBehavior);
         addBehavior(1,3,LightBehavior);
         addBehavior(1,4,ShotEffect_1_4);
         addBehavior(141,2,LaserBehavior);
         addBehavior(141,3,LaserBehavior);
         addBehavior(141,4,LaserBehavior);
         addBehavior(142,2,MissileBehavior);
         addBehavior(142,3,MissileBehavior);
         addBehavior(142,4,MissileBehavior);
         addBehavior(143,2,ShotEffect_143_2);
         addBehavior(143,3,ShotEffect_143_3);
         addBehavior(143,4,ShotEffect_143_4);
         addBehavior(144,2,ShotEffect_144_2);
         addBehavior(144,3,ShotEffect_144_3);
         addBehavior(144,4,ShotEffect_144_4);
      }
      
      public static function addBehavior(armID:uint, form:uint, behavior:Class) : void
      {
         hashMap.add(armID + "_" + form,behavior);
      }
      
      public static function removeBehavior(armID:uint) : void
      {
         hashMap.remove(armID);
      }
      
      public static function getBehavior(armID:uint, formID:uint) : IShotBehavior
      {
         var cls:Class = hashMap.getValue(armID + "_" + formID);
         if(cls == null)
         {
            return new EmptyBehavior();
         }
         return new cls() as IShotBehavior;
      }
      
      public static function getMovieClip(str:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(str,_loader);
      }
      
      public static function getButton(str:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(str,_loader);
      }
   }
}

