with System;
with GL.C;
with GL.C.Complete;

package body Meshes is


   procedure Setup (Item : in out Mesh) is
      use GL;
      use GL.Vertex_Array_Objects;
      use GL.Buffers;
      use GL.C;
      use GL.C.Complete;
      use System;
      use Vertices;
      use Vertices.Vertex_Vectors;
      use type GL.C.GLuint;
      use type GL.C.GLsizei;
      Stride : constant GLsizei := Vertex_Array'Component_Size / Storage_Unit;
   begin
      Item.VAO := Create_Attribute;
      Item.VBO := Create_Buffer;
      Set_Attribute_Enable (Item.VAO, 0);
      Set_Attribute_Enable (Item.VAO, 1);
      Set_Attribute_Memory_Layout (Item.VAO, 0, Float_Vector3'Length, Float_Type, False, 0);
      Set_Attribute_Memory_Layout (Item.VAO, 1, Float_Vector4'Length, Float_Type, False, Float_Vector3'Size / Storage_Unit);
      glVertexArrayAttribBinding (GLuint (Item.VAO), 0, 0);
      glVertexArrayAttribBinding (GLuint (Item.VAO), 1, 0);
      glVertexArrayVertexBuffer (GLuint (Item.VAO), 0, GLuint (Item.VBO), 0, Stride);
      Create_New_Storage (Item.VBO, Item.Data.Data_Size / Storage_Unit, Item.Data.Data_Address, Static_Usage);
   end;


   procedure Update (List : in out Mesh_Vectors.Vector) is
   begin
      for E : Mesh of List loop
         if E.State = Setup_Mesh_State then
            Setup (E);
            E.State := Draw_Mesh_State;
            exit;
         end if;
      end loop;
   end;


   procedure Draw (List : in out Mesh_Vectors.Vector) is
   begin
      for E : Mesh of List loop
         if E.State = Draw_Mesh_State then
            GL.Vertex_Array_Objects.Bind (E.VAO);
            GL.Drawings.Draw (E.Draw_Mode, 0, Integer (E.Data.Last_Index));
         end if;
      end loop;
   end;

   procedure Make_Triangle (Item : in out Mesh) is
      use GL;
      use GL.Buffers;
      use type GL.C.GLfloat;
   begin
      Item.Draw_Mode := GL.Drawings.Triangles_Mode;
      Item.Data.Append;
      Item.Data.Last_Element.Pos := (0.5, -0.5, 0.0);
      Item.Data.Last_Element.Col := (1.0, 0.0, 0.0, 1.0);
      Item.Data.Append;
      Item.Data.Last_Element.Pos := (-0.5, -0.5, 0.0);
      Item.Data.Last_Element.Col := (0.0, 1.0, 0.0, 1.0);
      Item.Data.Append;
      Item.Data.Last_Element.Pos := (0.0,  0.5, 0.0);
      Item.Data.Last_Element.Col := (0.0, 0.0, 1.0, 1.0);
   end;

   procedure Make_Grid_Lines (Item : in out Mesh) is
      use GL;
      use GL.Buffers;
      D : constant GLfloat := 10.0;
   begin
      --Item.Draw_Mode := GL.Drawings.Line_Strip_Mode;
      Item.Draw_Mode := GL.Drawings.Lines_Mode;
      for I in 1 .. 10 loop
         Item.Data.Append;
         Item.Data.Last_Element.Pos := (0.0, 0.0, GLfloat (I));
         Item.Data.Last_Element.Col := (0.0, 0.0, 1.0, 1.0);
         Item.Data.Append;
         Item.Data.Last_Element.Pos := (D, 0.0, GLfloat (I));
         Item.Data.Last_Element.Col := (0.0, 0.0, 1.0, 1.0);
         Item.Data.Append;
         Item.Data.Last_Element.Pos := (GLfloat (I), 0.0, 0.0);
         Item.Data.Last_Element.Col := (0.0, 0.0, 1.0, 1.0);
         Item.Data.Append;
         Item.Data.Last_Element.Pos := (GLfloat (I), 0.0, D);
         Item.Data.Last_Element.Col := (0.0, 0.0, 1.0, 1.0);
      end loop;
   end;


   procedure Make_Sin (Item : in out Mesh) is
      use GL;
      use GL.Buffers;
   begin
      Item.Draw_Mode := GL.Drawings.Line_Strip_Mode;
      for I in 1 .. 40 loop
         Item.Data.Append;
         Item.Data.Last_Element.Pos := (0.0, Elementary_Functions.Sin (GLfloat (I)), GLfloat (I));
         Item.Data.Last_Element.Col := (0.0, 1.0, 1.0, 1.0);
      end loop;
   end;




end;
