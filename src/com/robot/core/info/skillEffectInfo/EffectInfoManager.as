package com.robot.core.info.skillEffectInfo
{
   import flash.utils.getDefinitionByName;
   import org.taomee.ds.HashMap;
   
   public class EffectInfoManager
   {
      private static var hashMap:HashMap = new HashMap();
      
      public function EffectInfoManager()
      {
         super();
      }
      
      public static function getArgsNum(id:uint) : uint
      {
         return getEffect(id).argsNum;
      }
      
      public static function getInfo(id:uint, array:Array) : String
      {
         return getEffect(id).getInfo(array);
      }
      
      private static function getEffect(id:uint) : AbstractEffectInfo
      {
         var info:AbstractEffectInfo = null;
         var cls:* = undefined;
         if(hashMap.getValue(id))
         {
            info = hashMap.getValue(id);
         }
         else
         {
            cls = getDefinitionByName("com.robot.core.info.skillEffectInfo.Effect_" + id);
            info = new cls() as AbstractEffectInfo;
            hashMap.add(id,info);
         }
         return info;
      }
   }
}

