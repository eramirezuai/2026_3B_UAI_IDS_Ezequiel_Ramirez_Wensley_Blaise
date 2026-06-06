using Framework.Services.Localization;
using Framework.Services.Security.Log;
using GUI.Localization;
using System;
using System.Collections.Generic;
using System.Windows.Forms;
using CriteriaFunction = System.Func<Framework.Services.Security.Log.DataLogEntry, bool>;

namespace MusicRPG.Editor.Security.Forms
{
    public partial class FormSystemLog : LocalizableForm
    {
        enum SearchCriteriaOption
        {
            ByDate,
            ByUser,
            ByOption
        }

        class SearchCriteriaView
        {
            public SearchCriteriaOption Option { get; set; }
            public string Name { get; set; }

            public SearchCriteriaView(SearchCriteriaOption option, string name)
            {
                this.Option = option;
                this.Name = name; 
            }

            public override string ToString()
            {
                return Name;
            }
        }

        private List<SearchCriteriaView> criteria = new List<SearchCriteriaView>();
        private ILocalizableObject criteriaLocalizer;

        private Dictionary<SearchCriteriaOption, Func<string, CriteriaFunction>> searchers = new Dictionary<SearchCriteriaOption, Func<string, CriteriaFunction>>()
        {
            { SearchCriteriaOption.ByDate, (o) => ((entry) => entry.Date.Date == (DateTime.Parse(o)).Date) },
            { SearchCriteriaOption.ByUser, (o) => ((entry) => entry.User.Name.Equals(o)) },
            { SearchCriteriaOption.ByOption, (o) => ((entry) => (entry is DataLogDatabaseEntry ? (entry as DataLogDatabaseEntry).Operation.Equals(Enum.Parse(typeof(DataLogDatabaseOperation), o)) : false)) },
        };

        private List<object> logView = new List<object>();
        // View tag
        private object ViewTag = new object();
        private CriteriaFunction currentCriteria = null;

        private DataLogDatabaseCrud dataLogDatabaseCrud;

        public FormSystemLog() : base(Localizer.CurrentManager)
        {
            InitializeComponent();
        }

        private void CreateCriteriaView()
        {
            var criteriaByDate = new SearchCriteriaView(SearchCriteriaOption.ByDate, Localizer.CurrentManager.GetString("systemLog.criteria.date"));
            var criteriaByUser = new SearchCriteriaView(SearchCriteriaOption.ByUser, Localizer.CurrentManager.GetString("systemLog.criteria.user"));
            var criteriaByOption = new SearchCriteriaView(SearchCriteriaOption.ByOption, Localizer.CurrentManager.GetString("systemLog.criteria.option"));
            criteria = new List<SearchCriteriaView>()
            {
                criteriaByDate,
                criteriaByUser,
                criteriaByOption,
            };
            Localizer.LocalizeAction("systemLog.criteria.date", criteriaByDate, (text) => criteriaByDate.Name = text);
            Localizer.LocalizeAction("systemLog.criteria.user", criteriaByUser, (text) => criteriaByUser.Name = text);
            Localizer.LocalizeAction("systemLog.criteria.option", criteriaByOption, (text) => criteriaByOption.Name = text);
        }

        private void CreateView(IEnumerable<DataLogEntry> entries)
        {
            logView.Clear();
            foreach (var entry in entries)
            {
                //logView.Add(LocalizedView<DataLogEntry>.CreateViewFor(entry, new Dictionary<string, Func<DataLogEntry, object>>()
                //{
                //    { Localizer.CurrentManager.GetString("CAPTION_LOGENTRY_DATE"), ((e) => e.Date) },
                //    { Localizer.CurrentManager.GetString("CAPTION_LOGENTRY_USER"), ((e) => e.User.Name) },
                //    { Localizer.CurrentManager.GetString("CAPTION_LOGENTRY_DESC"), ((e) => e.Description) },
                //}));
            }
            UpdateGrid(grdSystemLog, logView);
        }

        private void CreateView()
        {
            //CreateView(DataLogEntryContainer.Instance.Items);
        }

        private void CreateView(CriteriaFunction criteria)
        {
            try
            {
                //CreateView(DataLogEntryContainer.Instance.Items.Where(criteria));
            }
            catch(Exception e)
            {
                //MessageBox.Show("");
            }
        }

        private void UpdateGrid(DataGridView grid, object list)
        {
            grid.DataSource = null;
            grid.DataSource = list;
            grid.ClearSelection();
        }

        private void FrmSystemLog_Closing(object sender, FormClosingEventArgs e)
        {
            UnloadLocalization();
        }

        protected override void LoadLocalization()
        {
            this.Tag = new LocalizableTag("system.patent.systemlog");
            LblSearchStartDate.Tag = new LocalizableTag("generic.field.startDate");
            LblSearchEndDate.Tag = new LocalizableTag("generic.field.endDate");
            LblSearchOperation.Tag = new LocalizableTag("systemLog.field.operation");
            LblSearchUsername.Tag = new LocalizableTag("generic.field.username");
            BtnSearchEntries.Tag = new LocalizableTag("generic.button.search");
            base.LoadLocalization();
        }

        private void FrmSystemLog_Load(object sender, EventArgs e)
        {
            this.FormClosing += FrmSystemLog_Closing;
            grdSystemLog.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            grdSystemLog.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            grdSystemLog.MultiSelect = false;
            LoadLocalization();
            CreateView();
        }

        private void SearchByFilter(SearchCriteriaOption criteria)
        {
            currentCriteria = searchers[criteria](TxtSearchFilter.Text);
            CreateView(currentCriteria);
        }

        private void BtnSearchEntries_Click(object sender, EventArgs e)
        {
            if (CmbSearchOperation.SelectedIndex >= 0 && CmbSearchOperation.SelectedIndex < CmbSearchOperation.Items.Count)
            {
                SearchByFilter((CmbSearchOperation.SelectedItem as SearchCriteriaView).Option);
            }
        }
    }
}
