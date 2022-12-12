

Add-Type -AssemblyName System.windows.Forms
Add-Type -AssemblyName System.Drawing


#Creación del Form (Interfaz)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Menú Principal'
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = 'CenterScreen'

#Creación de botón Aceptar
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'Aceptar'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.add($okButton)

#Creación de botón Cancelar
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancelar'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.add($cancelButton)

#Creación de Label "lije una opcion:"
$labOpcion = New-Object System.Windows.Forms.Label
$labOpcion.Location = New-Object System.Drawing.Point(10,50)
$labOpcion.Size = New-Object System.Drawing.Size(150,20)
$labOpcion.Text = 'Elije una opción:'
$form.Controls.add($labOpcion)

#Creación de comboBox
$cbOpcion = New-Object System.Windows.Forms.ComboBox
$cbOpcion.Location = New-Object System.Drawing.Point(160,50)
$cbOpcion.Size = New-Object System.Drawing.Size(310,20)
$cbOpcion.Items.AddRange(("Iniciar Programa", "Modificar Base de Datos"));
$cbOpcion.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$form.Controls.add($cbOpcion)

#Ejecutar ventana
$form.TopMost = $true
$result = $form.ShowDialog()

#si el resultado de la ventana es OK hacer lo siguiente:
if($result -eq [System.Windows.Forms.DialogResult]::OK){
    #Guarda la opción seleccionada en la variable
    $opcion = $cbOpcion.SelectedItem
    #Guarda
    switch ($opcion){
        "Iniciar Programa" {
            Write-Host "Iniciando programa"
            $form1 = New-Object System.Windows.Forms.Form
            $form1.Text = 'Inicio de programa'
            $form1.Size = New-Object System.Drawing.Size(500,300)
            $form1.StartPosition = 'CenterScreen'


            $form1.AcceptButton = $okButton
            $form1.Controls.add($okButton)

            $form1.CancelButton = $cancelButton
            $form1.Controls.add($cancelButton)

            $labOpcion = New-Object System.Windows.Forms.Label
            $labOpcion.Location = New-Object System.Drawing.Point(10,50)
            $labOpcion.Size = New-Object System.Drawing.Size(150,20)
            $labOpcion.Text = 'Elije una opción:'
            $form1.Controls.add($labOpcion)


            $cbOpcion = New-Object System.Windows.Forms.ComboBox
            $cbOpcion.Location = New-Object System.Drawing.Point(160,50)
            $cbOpcion.Size = New-Object System.Drawing.Size(310,20)
            $cbOpcion.Items.AddRange(("Subir archivos", "Crear directorios", "Listar procesos", "Detener procesos", "Enviar archivos", "Enviar mensajes", "Revisar mensajes"));
            $cbOpcion.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
            $form1.Controls.add($cbOpcion)

            $labUser = New-Object System.Windows.Forms.Label
            $labUser.Location = New-Object System.Drawing.Point(10,20)
            $labUser.Size = New-Object System.Drawing.Size(150,20)
            $labUser.Text = 'Ingrese usuario: '
            $form1.Controls.add($labUser)

            $txtUser = New-Object System.Windows.Forms.TextBox
            $txtUser.Location = New-Object System.Drawing.Point(160,20)
            $txtUser.Size = New-Object System.Drawing.Size(100,20)
            $form1.Controls.add($txtUser)

            $form1.TopMost = $true
            $result = $form1.ShowDialog()

            $opcion1=$cbOpcion.Text
            $usuarioDB= $txtUser.Text

            if($result -eq [System.Windows.Forms.DialogResult]::OK -and (Invoke-Sqlcmd -Query "USE Empleados; SELECT login FROM Empleado;" | Select-Object -ExpandProperty login) -eq  $usuarioDB){
                switch($opcion1){
                    "Subir archivos" {
                        Write-Host "Subiendo archivos..."
                        $form2 = New-Object System.Windows.Forms.Form
                        $form2.Text = 'Subida de archivos'
                        $form2.Size = New-Object System.Drawing.Size(500,300)
                        $form2.StartPosition = 'CenterScreen'


                        $form2.AcceptButton = $okButton
                        $form2.Controls.add($okButton)

                        $form2.CancelButton = $cancelButton
                        $form2.Controls.add($cancelButton)

                        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
                        $OpenFileDialog.initialDirectory = 'C:\Users\$usuarioDB'
                        $OpenFileDialog.filter = “All files (*.*)|*.*”
                        $OpenFileDialog.ShowDialog()
                        
                        $archivo=$OpenFileDialog.FileName

                        Write-Host $archivo

                        Copy-Item $archivo -Destination \\192.168.163.131\samba\tmp

                        #Seleccionar el directorio a donde se subir el archivo

                        $IDUsuario = (Invoke-Sqlcmd -Query "USE proyecto_programacion; SELECT ID_User FROM Usuarios WHERE Nombre = '$usuarioDB';")
                        $directorioDestino = (Invoke-Sqlcmd -Query "USE proyecto_programacion; SELECT Directorios.Directorio FROM Directorios INNER JOIN Usuarios ON Usuarios.ID_User = Directorios.ID_User;" )

                        $form3 = New-Object System.Windows.Forms.Form
                        $form3.Text = 'Seleccionar el directorio'
                        $form3.Size = New-Object System.Drawing.Size(500,300)
                        $form3.StartPosition = 'CenterScreen'

                        $form3.AcceptButton = $okButton
                        $form3.Controls.add($okButton)

                        $form3.CancelButton = $cancelButton
                        $form3.Controls.add($cancelButton)

                        $labFolder = New-Object System.Windows.Forms.Label
                        $labFolder.Location = New-Object System.Drawing.Point(10,50)
                        $labFolder.Size = New-Object System.Drawing.Size(150,20)
                        $labFolder.Text = 'Elije un directorio:'
                        $form3.Controls.add($labFolder)


                        $labFolder = New-Object System.Windows.Forms.ComboBox
                        $labFolder.Location = New-Object System.Drawing.Point(160,50)
                        $labFolder.Size = New-Object System.Drawing.Size(310,20)
                        $labFolder.Items.AddRange(("Subir archivos", "Crear directorios", "Listar procesos", "Detener procesos", "Enviar archivos", "Enviar mensajes", "Revisar mensajes"));
                        $labFolder.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
                        $form3.Controls.add($labFolder)

                        
                        #Mandar señar a linux para que mueva el fichero a 
                        

                    }
                    "Crear directorios" {
                        Write-Host "Creando directorios..."
                        #Menú en donde te permita escribir el nombre del directorio que se quiere crear
                        #Otro menú en el que te muestra los directorios disponibles de la base de datos
                    }
                    "Listar procesos" {
                        Write-Host "Listando procesos..."
                        #Crear un Archivo en donde estén almacenados los procesos
                        #Procesos.txt o Procesos.csv
                    }
                    "Detener procesos" {
                        Write-Host "Deteniendo procesos..."
                        #Archivo que tenga los procesos
                        #Un Menú donde estén los procesos
                    }
                    "Enviar archivos" {
                        Write-Host "Enviando archivos..."
                        #Seleccion de archivo y guardar ruta en variable
                    }
                    "Enviar mensajes" {
                        Write-Host "Enviando mensajes..."
                        #Carpeta llamada "CarpetaCompartida\mensajes"
                        #Enviar archivos txt con mensajes a esa carpeta
                    }
                    "Revisar mensajes" {
                        Write-Host "Revisando mensajes..."
                        #Leer archivos.txt de la carpeta mensajes
                    }
                    default {}
                }
            }
            else{
                Write-host "El usuario no existe en la base de datos"
            }
        }

        "Modificar Base de Datos" {
            #Menú de 3 opciones
            #dar de alta
                #uSUARIOS
                #DIRECTORIOS
                #LLAVES (CONTRASEÑAS)
            #dar de baja
            #y Modificar

        }
        default{}
    }

}
else{
    Write-Host "Adios!"
}