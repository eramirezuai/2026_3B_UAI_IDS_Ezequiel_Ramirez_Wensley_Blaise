using Fletex.Business;
using Framework.Services.Security.Credentials;
using System;
using System.Drawing;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Fletex.GUI
{
    public partial class FormUserPermissions : Form
    {
        
        public User baseUser;
        private UserBusiness userBLL;
        public FormUserPermissions()
        {
            InitializeComponent();
            userBLL = new UserBusiness();
        }

        private void FormUserPermissions_Load(object sender, EventArgs e)
        {
            //MessageBox.Show(user.Name);
            LoadVisualStyle();
            LoadUserWithPermissions();

        }

        private void LoadVisualStyle()
        {
            this.BackColor = SystemColors.ControlDark;
            this.ForeColor = Color.White;
            this.Font = new Font("Segoe UI", 10);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.MaximizeBox = false;
        }

        private void LoadUserWithPermissions()
        {
            User user = userBLL.GetUserWithPermissions(baseUser);
            

            LoadPermissionsTree(user);


        }

        private void LoadPermissionsTree(User user)
        {
            TreePermissions.Nodes.Clear();

            if (user?.Patent == null)
                return;

            // Crear nodo raíz con la patente principal del usuario
            TreeNode rootNode = new TreeNode(user.Name)
            {
                Tag = user.Patent
            };

            TreePermissions.Nodes.Add(rootNode);

            // Poblar recursivamente usando ChildPatents
            FillTreeWithPatents(rootNode, user.Patent);

            TreePermissions.ExpandAll();
        }

        private void FillTreeWithPatents(TreeNode parentNode, IPatent patent)
        {
            if (patent.ChildPatents == null)
                return;

            foreach (var child in patent.ChildPatents)
            {
                // Evitar agregar el propio objeto como hijo (Family lo devuelve en ChildPatents)
                if (child == patent)
                    continue;

                TreeNode childNode = new TreeNode($"{child.Code} - {child.Description}")
                {
                    Tag = child
                };

                parentNode.Nodes.Add(childNode);

                // Recursividad
                FillTreeWithPatents(childNode, child);
            }
        }

    }
}
