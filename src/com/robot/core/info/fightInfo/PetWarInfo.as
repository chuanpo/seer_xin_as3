package com.robot.core.info.fightInfo
{
   public class PetWarInfo
   {
      private var _myPetA:Array;
      
      private var _otherPetA:Array;
      
      public function PetWarInfo()
      {
         super();
      }
      
      public function get myPetA() : Array
      {
         return this._myPetA;
      }
      
      public function set myPetA(a:Array) : void
      {
         this._myPetA = a;
      }
      
      public function set otherPetA(a:Array) : void
      {
         this._otherPetA = a;
      }
      
      public function get otherPetA() : Array
      {
         return this._otherPetA;
      }
   }
}

