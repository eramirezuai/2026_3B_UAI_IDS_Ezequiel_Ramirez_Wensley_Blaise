namespace MusicRPG.Editor.Security.Forms
{
    partial class FormSystemLog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.LblSearchUsername = new System.Windows.Forms.Label();
            this.TxtSearchFilter = new System.Windows.Forms.TextBox();
            this.BtnSearchEntries = new System.Windows.Forms.Button();
            this.CmbSearchOperation = new System.Windows.Forms.ComboBox();
            this.grdSystemLog = new System.Windows.Forms.DataGridView();
            this.Fecha = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LblSearchOperation = new System.Windows.Forms.Label();
            this.LblSearchStartDate = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.LblSearchEndDate = new System.Windows.Forms.Label();
            this.DtpStartDate = new System.Windows.Forms.DateTimePicker();
            this.DtpEndDate = new System.Windows.Forms.DateTimePicker();
            ((System.ComponentModel.ISupportInitialize)(this.grdSystemLog)).BeginInit();
            this.SuspendLayout();
            // 
            // LblSearchUsername
            // 
            this.LblSearchUsername.AutoSize = true;
            this.LblSearchUsername.Location = new System.Drawing.Point(12, 9);
            this.LblSearchUsername.Name = "LblSearchUsername";
            this.LblSearchUsername.Size = new System.Drawing.Size(46, 13);
            this.LblSearchUsername.TabIndex = 0;
            this.LblSearchUsername.Text = "Usuario:";
            // 
            // TxtSearchFilter
            // 
            this.TxtSearchFilter.Location = new System.Drawing.Point(82, 6);
            this.TxtSearchFilter.Name = "TxtSearchFilter";
            this.TxtSearchFilter.Size = new System.Drawing.Size(200, 20);
            this.TxtSearchFilter.TabIndex = 1;
            // 
            // BtnSearchEntries
            // 
            this.BtnSearchEntries.Location = new System.Drawing.Point(641, 4);
            this.BtnSearchEntries.Name = "BtnSearchEntries";
            this.BtnSearchEntries.Size = new System.Drawing.Size(75, 23);
            this.BtnSearchEntries.TabIndex = 2;
            this.BtnSearchEntries.Text = "Buscar";
            this.BtnSearchEntries.UseVisualStyleBackColor = true;
            this.BtnSearchEntries.Click += new System.EventHandler(this.BtnSearchEntries_Click);
            // 
            // CmbSearchOperation
            // 
            this.CmbSearchOperation.FormattingEnabled = true;
            this.CmbSearchOperation.Location = new System.Drawing.Point(429, 6);
            this.CmbSearchOperation.Name = "CmbSearchOperation";
            this.CmbSearchOperation.Size = new System.Drawing.Size(200, 21);
            this.CmbSearchOperation.TabIndex = 3;
            // 
            // grdSystemLog
            // 
            this.grdSystemLog.AllowUserToAddRows = false;
            this.grdSystemLog.AllowUserToDeleteRows = false;
            this.grdSystemLog.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.grdSystemLog.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Fecha,
            this.Column1,
            this.Column2});
            this.grdSystemLog.Location = new System.Drawing.Point(15, 61);
            this.grdSystemLog.Name = "grdSystemLog";
            this.grdSystemLog.ReadOnly = true;
            this.grdSystemLog.Size = new System.Drawing.Size(701, 347);
            this.grdSystemLog.TabIndex = 4;
            // 
            // Fecha
            // 
            this.Fecha.HeaderText = "Fecha";
            this.Fecha.Name = "Fecha";
            this.Fecha.ReadOnly = true;
            // 
            // Column1
            // 
            this.Column1.HeaderText = "Usuario";
            this.Column1.Name = "Column1";
            this.Column1.ReadOnly = true;
            // 
            // Column2
            // 
            this.Column2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Column2.HeaderText = "Descripción";
            this.Column2.Name = "Column2";
            this.Column2.ReadOnly = true;
            // 
            // LblSearchOperation
            // 
            this.LblSearchOperation.AutoSize = true;
            this.LblSearchOperation.Location = new System.Drawing.Point(327, 9);
            this.LblSearchOperation.Name = "LblSearchOperation";
            this.LblSearchOperation.Size = new System.Drawing.Size(59, 13);
            this.LblSearchOperation.TabIndex = 0;
            this.LblSearchOperation.Text = "Operación:";
            // 
            // LblSearchStartDate
            // 
            this.LblSearchStartDate.AutoSize = true;
            this.LblSearchStartDate.Location = new System.Drawing.Point(12, 37);
            this.LblSearchStartDate.Name = "LblSearchStartDate";
            this.LblSearchStartDate.Size = new System.Drawing.Size(68, 13);
            this.LblSearchStartDate.TabIndex = 0;
            this.LblSearchStartDate.Text = "Fecha Inicio:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(188, 106);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(68, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Fecha Inicio:";
            // 
            // LblSearchEndDate
            // 
            this.LblSearchEndDate.AutoSize = true;
            this.LblSearchEndDate.Location = new System.Drawing.Point(327, 37);
            this.LblSearchEndDate.Name = "LblSearchEndDate";
            this.LblSearchEndDate.Size = new System.Drawing.Size(57, 13);
            this.LblSearchEndDate.TabIndex = 0;
            this.LblSearchEndDate.Text = "Fecha Fin:";
            // 
            // DtpStartDate
            // 
            this.DtpStartDate.Location = new System.Drawing.Point(82, 32);
            this.DtpStartDate.Name = "DtpStartDate";
            this.DtpStartDate.Size = new System.Drawing.Size(200, 20);
            this.DtpStartDate.TabIndex = 5;
            // 
            // DtpEndDate
            // 
            this.DtpEndDate.Location = new System.Drawing.Point(429, 32);
            this.DtpEndDate.Name = "DtpEndDate";
            this.DtpEndDate.Size = new System.Drawing.Size(200, 20);
            this.DtpEndDate.TabIndex = 5;
            // 
            // FormSystemLog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(728, 421);
            this.Controls.Add(this.DtpEndDate);
            this.Controls.Add(this.DtpStartDate);
            this.Controls.Add(this.grdSystemLog);
            this.Controls.Add(this.CmbSearchOperation);
            this.Controls.Add(this.BtnSearchEntries);
            this.Controls.Add(this.TxtSearchFilter);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.LblSearchEndDate);
            this.Controls.Add(this.LblSearchStartDate);
            this.Controls.Add(this.LblSearchOperation);
            this.Controls.Add(this.LblSearchUsername);
            this.Name = "FormSystemLog";
            this.ShowIcon = false;
            this.Text = "Auditoría del Sistema";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FrmSystemLog_Closing);
            this.Load += new System.EventHandler(this.FrmSystemLog_Load);
            ((System.ComponentModel.ISupportInitialize)(this.grdSystemLog)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label LblSearchUsername;
        private System.Windows.Forms.TextBox TxtSearchFilter;
        private System.Windows.Forms.Button BtnSearchEntries;
        private System.Windows.Forms.ComboBox CmbSearchOperation;
        private System.Windows.Forms.DataGridView grdSystemLog;
        private System.Windows.Forms.DataGridViewTextBoxColumn Fecha;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column1;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column2;
        private System.Windows.Forms.Label LblSearchOperation;
        private System.Windows.Forms.Label LblSearchStartDate;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label LblSearchEndDate;
        private System.Windows.Forms.DateTimePicker DtpStartDate;
        private System.Windows.Forms.DateTimePicker DtpEndDate;
    }
}