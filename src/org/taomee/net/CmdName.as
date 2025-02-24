package org.taomee.net
{
   import org.taomee.ds.HashMap;
   
   public class CmdName
   {
      private static var _list:HashMap = new HashMap();
      
      public function CmdName()
      {
         super();
      }
      
      public static function getName(id:uint) : String
      {
         var str:String = _list.getValue(id);
         if(Boolean(str))
         {
            return str;
         }
         return "---";
      }
      
      public static function addName(cmdID:uint, name:String) : void
      {
         _list.add(cmdID,name);
      }
   }
}

