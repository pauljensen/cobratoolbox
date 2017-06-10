function FileString = generateFieldDescriptionFile(FileName)
% Generates the ModelFields.md file describing the Required and Optional Fields of a COBRA model.
%
% USAGE:
%
%    FileString = generateFieldDescriptionFile(FileName)
%
% OPTIONAL INPUT:
%    FileName:      The FileName to write to. (default [CBTDIR filesep 'docs' filesep 'notes' filesep 'COBRAModelFields.md'])
%
% OUTPUT:
%    FileString:    The string written to the specified filename (or the default file)
%
% .. Author: - Thomas Pfau May 2017

global CBTDIR
if ~exist('FileName','var')
    if isempty(CBTDIR)
        initCobraToolbox
    end
    FileName = [CBTDIR filesep 'docs' filesep 'notes' filesep 'COBRAModelFields.md'];
end

fieldProperties = getDefinedFieldProperties('Descriptions', true);


FileString = sprintf('# Fields in the model structure\n\n');
FileString = strjoin({FileString, sprintf(['Contents:\n',...
                                        '1. [Model Fields](#model-fields)\n',...
                    '2. [Field Support](#field-support)\n',...
					'3. [Model Specific Fields](#model-specific-fields)\n',...
					'4. [Annotation Definitions](#annotation-definitions)\n',...
					'\n',...
					'### Model Fields: \n',...
					'The following fields are defined in the COBRA toolbox. IF the field is present in a model, it should have the properties defined here and should be of the mentioned dimensions.\n '...
                    'The dimensions refer to m (the number of metabolites), n (the number of reactions), g (the number of genes) and c (the number of compartments).\n',...
					'\n',...
					'| Field Name | Dimension | Field Type | Field Description | \n',...
					'|---|---|---|---|\n'])},'');

for i=1:size(fieldProperties,1)
	string = sprintf('|`model.%s`| `%s` | %s | %s | \n',fieldProperties{i,1},fieldProperties{i,2},fieldProperties{i,3},fieldProperties{i,4});
	FileString = strjoin({FileString,string},'');
end
FileString = strjoin({FileString,sprintf(['### Model Specific Fields\n',...
					'Some models might contain additional model specific fields that are not defined COBRA model fields. These fields will commonly not be considered by COBRA toolbox methods, and using toolbox methods can render these fields inconsistent (e.g. if the number of reactions changes, a model specific field linked to reactions might have the wrong number of entries or the values might no longer correspond to the correct indices). \n',...
					'\n',...
					'### Field Support\n',...
					'All fields mentioned above are supported by COBRA Toolbox functions.'...
                    'Using COBRA Toolbox Functions will not make a model inconsistent, but manual modifications of fields might lead to an inconsistent model.\n',...
					'Use verifyModel(model) to determine, if the model is a valid COBRA Toolbox model.\n',...
					'\n',...
					'### Additional fields\n',...
					'Fields starting with met, rxn, comp, protein or gene that are not defined above, will be assumed to be annotation fields, and IO methods will try to map them to identifiers.org registered databases.'])},'');
fileID = fopen(FileName,'w');
fprintf(fileID,FileString);
fclose(fileID);