using System;
using System.Windows.Forms;

namespace Fletex.GUI
{
    public partial class FormMain : Form
    {
        public FormMain()
        {
            InitializeComponent();
        }

        private void FormMain_Load(object sender, EventArgs e)
        {
            FormLogin frm = new FormLogin();
            if (frm.ShowDialog() == DialogResult.OK)
            {
                lblUser.Text = frm.userName;
            }
        }

        private void panelUsuariosToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void userManagementToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormUserManagement frm = new FormUserManagement();
            frm.ShowDialog();
        }
    }
}
