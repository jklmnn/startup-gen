pragma Ada_12;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

with GNATCOLL.Projects; use GNATCOLL.Projects;

package Device is

   type Spec is tagged private;
   --  TODO In post-condition we check that the memory is well formed.
   procedure Set_Memory_List (Self : in out Spec; Path : String) with
      Post => (True);

   --  TODO: move in a different package, it does not belong here
   --  Calls Register_New_Attribute with the correct attributes to setup the
   --  syntax for a GPR file containing a memory map.
   procedure Register_Memory_Map_Attributes with
      Post => (Attribute_Registered ("Types", "Memory")
           and Attribute_Registered ("Size", "Memory")
           and Attribute_Registered ("Start", "Memory")
         );

private
   type Interrupt_Type is
      record
         Name : Unbounded_String;
      end record;

   type Float_Type is (Hard, Soft);

   type CPU_Type is
      record
         Name : Unbounded_String;
         Float_Handling : Float_Type;
      end record;

   type Memory_Kind is (RAM, ROM, TCM, CCM);

   type Memory_Type is
      record
         Name : Unbounded_String;
         Start : Natural; --  We can start the ROM at zero.
         Size : Positive;
         Kind : Memory_Kind;
      end record;

   package Int_Vect is new Ada.Containers.Vectors (Positive, Interrupt_Type);
   package Mem_Vect is new Ada.Containers.Vectors (Positive, Memory_Type);

   type Spec is tagged
      record
         Memory : Mem_Vect.Vector;
         CPU : CPU_Type;
         InterruptVector : Int_Vect.Vector;
      end record;

end Device;
