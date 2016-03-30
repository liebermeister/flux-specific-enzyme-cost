function ecm_save_model_and_data_gams(filename,network,v,r,c_data,u_data,ecm_options)

display(sprintf('Writing model files (gams format) to directory\n%s', filename))

% adjust names for sbml output

[network.metabolites,network.actions] = network_adjust_names_for_sbml_export(network.metabolites,network.actions,1);

ecm_options.fix_metabolites = network_adjust_names_for_sbml_export(ecm_options.fix_metabolites,[],1);

% turn network + kinetics into sbtab format

network.kinetics = r;
network.kinetics.type = 'cs';
network_sbtab = network_to_sbtab(network, struct('use_sbml_ids',0,'verbose',0,'write_concentrations',0,'write_enzyme_concentrations',0));

quantity_type = network_sbtab.tables.Quantity.column.column.QuantityType;
value         = network_sbtab.tables.Quantity.column.column.Value;
compound      = network_sbtab.tables.Quantity.column.column.Compound;
reaction      = network_sbtab.tables.Quantity.column.column.Reaction;

[compound,reaction] = network_adjust_names_for_sbml_export(compound,reaction,1);

display('Writing GAMS files');

% write table efms.tsv

mytable([ [{'efms'}; network.actions], [{1}; num2cell(v)] ]','comma',[filename 'efms.tsv']);

% write table metfixed.tsv

mytable([column(ecm_options.met_fix), num2cell(column(ecm_options.conc_fix))],'comma',[filename 'metfixed.tsv']);

% write table boundse.tsv

[nm,nr] = size(network.N);

mytable([[network.actions, repmat({'lo','0'},nr,1)]; ...
         [network.actions, repmat({'up','100'},nr,1)]],'comma',[filename 'boundse.tsv']);

% write table boundsx.tsv

mytable([[network.metabolites, repmat({'lo'},nm,1), num2cell(log10(ecm_options.conc_min))]; ...
         [network.metabolites, repmat({'up'},nm,1), num2cell(log10(ecm_options.conc_max))]],'comma',[filename 'boundsx.tsv']);

% write table metmoiety.tsv

% write table moiety.tsv

% write table newmet.tsv

% write table activators.tsv

ind = find(strcmp('activation constant', quantity_type));
mytable([compound(ind), reaction(ind), num2cell(value(ind))],'comma',[filename 'activators.tsv']);

% write table inhibitors.tsv

ind = find(strcmp('inhibition constant', quantity_type));
mytable([compound(ind), reaction(ind), num2cell(value(ind))],'comma',[filename 'inhibitors.tsv']);

% write table kcats.tsv

ind = find(strcmp('substrate catalytic rate constant', quantity_type));
mytable([reaction(ind), num2cell(value(ind))],'comma',[filename 'kcats.tsv']);

% write table keqs.tsv

ind = find(strcmp('equilibrium constant', quantity_type));
mytable([reaction(ind), num2cell(value(ind))],'comma',[filename 'keqs.tsv']);

% write table kmstoich.tsv

ind = find(strcmp('Michaelis constant', quantity_type));

stoich = [];
for it = 1:length(ind),
  i_met = find(strcmp(compound{ind(it)},network.metabolites));
  i_rea = find(strcmp(reaction{ind(it)},network.actions));
  stoich(it,1) = network.N(i_met,i_rea);
end

mytable([compound(ind), reaction(ind), num2cell([stoich, value(ind)])],'comma',[filename 'kmstoich.tsv']);

eval(sprintf(' cd %s; zip MODEL.zip *tsv;', filename));
