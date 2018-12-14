function ecm_options = ecm_default_options(network, model_name)

% ECM_DEFAULT_OPTIONS -  Defaults for ECM
% 
% ecm_options = ecm_default_options(network, model_name)
%
% ecm options and their default values
%
% model
%   ecm_options.model_name               = model_name         ; 
%   ecm_options.run_id                   = 'RUN';
%   ecm_options.model_id                 = 'MODEL';
% 
% metabolite constraints
%   ecm_options.fix_metabolites          = {}; % metabolites with fixed concentrations (overrides values from input model)
%   ecm_options.fix_metabolite_values    = [];
%   ecm_options.conc_min_default         = 0.001              ; % mM
%   ecm_options.conc_max_default         = 10                 ; % mM
%   ecm_options.conc_min                 = [];% 0.001 * ones(nm,1) ; % mM
%   ecm_options.conc_max                 = [];% 10 * ones(nm,1);   ; % mM
%   ecm_options.conc_fix                 = [];
%   ecm_options.met_fix                  = [];
%   ecm_options.replace_cofactors        = {};  % names of cofactors; this is only used in ecm_update_options.m - bounds for cofactor concentrations are automatically set based on median value from concentration data
% 
% given data
%   ecm_options.c_data                   = [];
%   ecm_options.u_data                   = [];
%   ecm_options.kinetic_data             = [];
% 
% kinetic data
%   ecm_options.reaction_column_names    = []; % column names (in data file) for loading of kinetic data
%   ecm_options.compound_column_names    = [];
%   ecm_options.KM_lower                 = []; % mM
%   ecm_options.Keq_upper                = [];
%   ecm_options.flag_given_kinetics      = 0;
%   ecm_options.kcat_usage               = 'use';
%   ecm_options.kcat_upper               = 10000;  % 1/s
%   ecm_options.kcat_lower               = 0.1;    % 1/s
%   ecm_options.kcatr_lower              = 0.0001; % 1/s
%   ecm_options.kcat_prior_median        = 10;     % for ccm this value need to be modified
%   ecm_options.kcat_prior_log10_std     = 0.2;   % reduce spread of kcat values
%   ecm_options.GFE_fixed                = 1;     % flag
%   ecm_options.insert_Keq_from_data     = 0;     % flag
% 
% parameter balancing
%   ecm_options.n_samples = 0;
%   ecm_options.use_pseudo_values = 1;
% 
% enzyme cost weights
%   ecm_options.ind_scored_enzymes       = [1:length(network.actions)]';
%   ecm_options.enzyme_cost_weights      = ones(length(ecm_options.ind_scored_enzymes),1);
%   ecm_options.use_cost_weights         = 'none';
% 
% ecm
%   ecm_options.initial_choice           = 'mdf'; also {'polytope_center', 'interval_center', 'given_x_start'}
%   ecm_options.x_start                  = []; 
%   ecm_options.fix_thermodynamics_by_adjusting_Keq = 1;
%   ecm_options.multiple_conditions      = 0;
%   ecm_options.multiple_conditions_n    = 1;
%   ecm_options.multiple_starting_points = 0;
%   ecm_options.ecm_scores               = {'emc3sp'}           ;
%   ecm_options.lambda_regularisation    = 10^-3; 
%   ecm_options.lambda_reg_factor        = 0.01;
%   ecm_options.parameter_prior_file     = [];
%   ecm_options.use_linear_cost_constraints = 1; % tighter constraints derived upper bound on enzyme cost 
%   ecm_options.fluctuations_safety_margin = 0; % safety margin (# std dev) to counter protein number fluctuations
%   ecm_options.cell_volume              = 1.1*10^-18;  % in m^3, default value for E coli (needed for safety margin) 
%   ecm_options.maximal_u_cost           = []; % used with option "use_linear_cost_constraints"
%   ecm_options.compute_hessian          = 0;
%   ecm_options.compute_elasticities     = 0;
%   ecm_options.compute_tolerance        = 0;
%   ecm_options.cost_tolerance_factor    = 1.01; % one percent
%   ecm_options.tolerance_from_hessian   = 0;
%   ecm_options.fix_Keq_in_sampling      = 0;
% 
% graphics
%   ecm_options.print_graphics           = 0;
%   ecm_options.show_graphics            = 1;
%   ecm_options.show_metabolites         = network.metabolites;
%   ecm_options.metabolite_order_file    = [];
%   ecm_options.reaction_order_file      = [];
% 
%   ecm_options.verbose                  = 0;

% Argument 'model_name' is optional

[nm,nr] = size(network.N);

eval(default('model_name','''model'''));

ecm_options = struct;

% model
ecm_options.model_name               = model_name         ; 
ecm_options.run_id                   = 'RUN';
ecm_options.model_id                 = 'MODEL';

% given data
ecm_options.c_data                   = [];
ecm_options.u_data                   = [];
ecm_options.kinetic_data             = [];

% add parameter balancing options
ecm_options = join_struct(ecm_options, parameter_balancing_options);
ecm_options.kcat_prior_median        = 10;     % for ccm this value need to be modified
ecm_options.kcat_prior_log10_std     = 0.2;   % reduce spread of kcat values
ecm_options.kcat_upper               = 10000;  % 1/s
ecm_options.kcat_lower               = 0.1;    % 1/s
ecm_options.kcatr_lower              = 0.0001; % 1/s
ecm_options.GFE_fixed                = 1;     % flag

% metabolite constraints
ecm_options.fix_metabolites          = {}; % metabolites with fixed concentrations (overrides values from input model)
ecm_options.fix_metabolite_values    = [];
ecm_options.conc_min_default         = 0.001; % mM
ecm_options.conc_max_default         = 10;  % mM
ecm_options.conc_min                 = [];
ecm_options.conc_max                 = [];
ecm_options.conc_fix                 = [];
ecm_options.ind_met_fix              = [];
ecm_options.met_fix                  = [];
ecm_options.replace_cofactors        = {};

% kinetic data
ecm_options.reaction_column_names    = []; % column names (in data file) for loading of kinetic data
ecm_options.compound_column_names    = [];
ecm_options.flag_given_kinetics      = 0;
ecm_options.insert_Keq_from_data     = 0;     % flag

% enzyme cost weights
ecm_options.ind_scored_enzymes       = [1:length(network.actions)]';
ecm_options.enzyme_cost_weights      = ones(length(ecm_options.ind_scored_enzymes),1);
ecm_options.use_cost_weights         = 'none';

% ecm
ecm_options.initial_choice              = 'polytope_center';
ecm_options.x_start                     = []; 
ecm_options.fix_thermodynamics_by_adjusting_Keq = 1;
ecm_options.multiple_conditions         = 0;
ecm_options.multiple_conditions_n       = 1;
ecm_options.multiple_starting_points    = 0;
ecm_options.ecm_scores                  = {'emc3sp'}           ;
ecm_options.lambda_regularisation       = 10^-3; 
ecm_options.lambda_reg_factor           = 0.01;
ecm_options.parameter_prior_file        = [];
ecm_options.use_linear_cost_constraints = 1; 
ecm_options.fluctuations_safety_margin  = 0; % safety margin, to counter protein number fluctuations
ecm_options.cell_volume                 = 1.1*10^-18;  % in m^3, default value for E coli (needed for safety margin) 
ecm_options.maximal_u_cost              = []; 
ecm_options.compute_hessian             = 0;
ecm_options.compute_elasticities        = 0;
ecm_options.compute_tolerance           = 0;
ecm_options.cost_tolerance_factor       = 1.01; % one percent
ecm_options.tolerance_from_hessian      = 0;
ecm_options.fix_Keq_in_sampling         = 0;

% graphics
ecm_options.print_graphics           = 0;
ecm_options.show_graphics            = 1;
ecm_options.show_metabolites         = network.metabolites;
ecm_options.metabolite_order_file    = [];
ecm_options.reaction_order_file      = [];

% general
ecm_options.verbose                  = 0;
